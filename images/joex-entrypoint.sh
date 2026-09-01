#!/bin/sh

set -e

echo "Starting unoserver"
# Queues office converts so concurrent joex workers do not deadlock LibreOffice.
# See https://github.com/eikek/docspell/issues/3345
unoserver --conversion-timeout 120 &

echo "Waiting for unoserver to become ready"
i=0
while [ "$i" -lt 60 ]; do
  if unoping >/dev/null 2>&1; then
    echo "unoserver is ready"
    break
  fi
  i=$((i + 1))
  sleep 1
done

if ! unoping >/dev/null 2>&1; then
  echo "WARNING: unoserver did not become ready within 60s; office conversion may fail" >&2
fi

/opt/docspell-joex/bin/docspell-joex "$@"
