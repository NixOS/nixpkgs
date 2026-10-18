#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p python3 nix nixfmt
# shellcheck shell=bash

# Regenerate workload pack data for all supported .NET versions.
# Run from the nixpkgs root:
#   ./pkgs/development/compilers/dotnet/update-workloads.sh [version...]
#
# Examples:
#   ./pkgs/development/compilers/dotnet/update-workloads.sh        # all versions
#   ./pkgs/development/compilers/dotnet/update-workloads.sh 10.0   # just 10.0

set -Eeuo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec python3 "$script_dir/generate-workload-data.py" --write "$@"
