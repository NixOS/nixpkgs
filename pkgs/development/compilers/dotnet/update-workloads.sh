#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p python3 nix
# shellcheck shell=bash

# Regenerate workload pack data for all supported .NET versions.
# Run from the nixpkgs root:
#   ./pkgs/development/compilers/dotnet/update-workloads.sh [version...]
#
# Examples:
#   ./pkgs/development/compilers/dotnet/update-workloads.sh        # all versions
#   ./pkgs/development/compilers/dotnet/update-workloads.sh 9.0    # just 9.0

set -Eeuo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
generator="$script_dir/generate-workload-data.py"
workloads_dir="$script_dir/workloads"

# Derive supported versions from existing workload data files.
if (( $# > 0 )); then
    versions=("$@")
else
    versions=()
    for f in "$workloads_dir"/*.nix; do
        [[ -f "$f" ]] || continue
        versions+=("$(basename "${f%.nix}")")
    done
fi

mkdir -p "$workloads_dir"

for version in "${versions[@]}"; do
    echo "=== Generating workload data for .NET $version ==="
    python3 "$generator" "$version" > "$workloads_dir/$version.nix"
    echo "    Wrote $workloads_dir/$version.nix ($(wc -l < "$workloads_dir/$version.nix") lines)"
done

echo "Done."
