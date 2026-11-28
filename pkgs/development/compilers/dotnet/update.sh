#!/bin/sh
# shellcheck shell=bash

set -Eeuo pipefail

pkgs/development/compilers/dotnet/binary/update.sh "$@"
pkgs/development/compilers/dotnet/source/update.sh "$@"

workload_channels=()
for channel in "$@"; do
  if [[ -f "pkgs/development/compilers/dotnet/workloads/$channel.nix" ]]; then
    workload_channels+=("$channel")
  fi
done
if (( ${#workload_channels[@]} > 0 )); then
  pkgs/development/compilers/dotnet/update-workloads.sh "${workload_channels[@]}"
fi
