#! /usr/bin/env nix-shell
#! nix-shell -p python3 dotnet-sdk_3 -i bash
# shellcheck shell=bash

# Run this script to generate deps.nix
# ./create_deps.sh /path/to/microsoft/python/language/server/source/checkout

set -euo pipefail

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ -d "$1" ]; then
    CHECKOUT_PATH="$1"
else
    echo "First argument must be a directory, the path to the Microsoft Python Language Server source checkout"
    exit 1
fi

# Generate lockfiles in source checkout
cd "$CHECKOUT_PATH/src"
dotnet nuget locals all --clear
dotnet restore -v normal --no-cache PLS.sln --use-lock-file -r linux-x64

# Use the lockfiles to make a file with two columns: name and version number
# for all possible package dependencies
cd "$SCRIPTDIR"
echo "" > all_versions.txt
for lockfile in $(find "$CHECKOUT_PATH" -name packages.lock.json); do
    echo "Processing lockfile $lockfile"
    python ./process_lockfile.py "$lockfile" >> all_versions.txt
done
# Add extra manually added packages
cat ./manual_deps.txt >> all_versions.txt
cat all_versions.txt | sed '/^$/d' | sort | uniq > tmp
mv tmp all_versions.txt

# Retrieve sha256 hashes for each dependency and format fetchNuGet calls into deps.nix
./format-deps.sh all_versions.txt > deps.nix
rm all_versions.txt
