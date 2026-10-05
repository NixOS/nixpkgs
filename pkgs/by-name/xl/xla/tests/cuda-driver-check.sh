#!/usr/bin/env bash

set -euo pipefail

repository=$1
toolkit_stub=$2
driver_directory="$repository/lib"
driver="$driver_directory/libcuda.so.1"

if [[ ! -d "$driver_directory" ]]; then
  echo "missing CUDA driver repository directory: $driver_directory" >&2
  exit 1
fi
if [[ -L "$driver_directory" ]]; then
  echo "CUDA driver repository directory is a symlink: $driver_directory" >&2
  exit 1
fi
if [[ ! -e "$driver" ]]; then
  echo "missing CUDA driver artifact: $driver" >&2
  exit 1
fi
if [[ ! -e "$toolkit_stub" ]]; then
  echo "missing selected toolkit driver stub: $toolkit_stub" >&2
  exit 1
fi

resolved_driver=$(readlink -f "$driver")
resolved_stub=$(readlink -f "$toolkit_stub")
if [[ "$resolved_driver" == "$resolved_stub" ]]; then
  echo "CUDA driver repository resolves to the selected toolkit stub" >&2
  exit 1
fi
if cmp -s "$resolved_driver" "$resolved_stub"; then
  echo "CUDA driver repository contains a copy of the selected toolkit stub" >&2
  exit 1
fi
