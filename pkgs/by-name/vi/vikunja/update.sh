#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix wget jq nurl

# shellcheck shell=bash

set -euo pipefail

if [[ $# -gt 1 || "${1:-}" == -* ]]; then
    echo "Regenerates packaging data for the vikunja package."
    echo "Usage: $0 [version]"
    exit 1
fi

version="${1:-}"

NIXPKGS_ROOT="$(git rev-parse --show-toplevel)"

if [ -z "$version" ]; then
    TOKEN_ARGS=()
    if [ -n "${GITHUB_TOKEN:-}" ]; then
        TOKEN_ARGS=(--header "Authorization: token $GITHUB_TOKEN")
    fi
    version="$(wget -q -O- ${TOKEN_ARGS[@]+"${TOKEN_ARGS[@]}"} "https://api.github.com/repos/go-vikunja/vikunja/releases?per_page=10" | jq -r '[.[] | select(.prerelease == false)][0].tag_name')"
fi

# strip leading "v"
version="${version#v}"

cd "$(dirname "$0")"

# Update version, blank out all hashes so nurl can recompute them
sed -i -E 's#version = ".*"#version = "'"$version"'"#' package.nix
sed -i -E '/fetchFromGitHub \{/,/\};/ s#hash = ".*"#hash = ""#' package.nix
sed -i -E '/fetchPnpmDeps \{/,/\};/ s#hash = ".*"#hash = ""#' package.nix
sed -i -E 's#vendorHash = ".*"#vendorHash = ""#' package.nix

# Source hash (must be computed first, pnpm and vendor depend on it)
src_hash=$(nurl -e "(import $NIXPKGS_ROOT/. { }).vikunja.src")
sed -i -E '/fetchFromGitHub \{/,/\};/ s#hash = ".*"#hash = "'"$src_hash"'"#' package.nix

# pnpm dependencies hash for frontend
pnpm_hash=$(nurl -e "(import $NIXPKGS_ROOT/. { }).vikunja.frontend.pnpmDeps")
sed -i -E '/fetchPnpmDeps \{/,/\};/ s#hash = ".*"#hash = "'"$pnpm_hash"'"#' package.nix

# Go modules vendor hash
vendor_hash=$(nurl -e "(import $NIXPKGS_ROOT/. { }).vikunja.goModules")
sed -i -E 's#vendorHash = ".*"#vendorHash = "'"$vendor_hash"'"#' package.nix

echo "Update complete!"
echo "Version: $version"
echo "Source hash: $src_hash"
echo "Frontend pnpm hash: $pnpm_hash"
echo "Go vendor hash: $vendor_hash"
