#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update cargo
# shellcheck shell=bash

set -euf -o pipefail

# toposorted manually, please keep in order
PACKAGES=(
    "folly"
    "fizz"
    "mvfst"
    "wangle"
    "fbthrift"
    "fb303"
    "edencommon"
)

for P in "${PACKAGES[@]}"; do
    nix-update "$P" --commit
done

nix-update watchman --commit --generate-lockfile --lockfile-metadata-path "watchman/cli"
