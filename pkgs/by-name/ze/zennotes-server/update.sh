#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update curl jq nix

set -euo pipefail
file="$(dirname "$0")/package.nix"
pkg="zennotes-server"

nix-update "$pkg"

version="$(nix eval --raw ".#${pkg}.version")"

manifest_json="$(curl -sSL "https://raw.githubusercontent.com/ZenNotes/znserver/refs/tags/v${version}/web-artifact/manifest.json")"

archive_url="$(jq -r '.archive.url' <<< "$manifest_json")"
archive_sha256="$(jq -r '.archive.sha256' <<< "$manifest_json")"

# Convert sha256 to sri hash
archive_hash="$(nix hash convert --hash-algo sha256 --to sri $archive_sha256)"

sed -i \
  -e "/webArchive = fetchurl {/,/};/s#url = \"https://[^\"]*\"#url = \"${archive_url}\"#" \
  -e "/webArchive = fetchurl {/,/};/s#hash = \"[^\"]*\"#hash = \"${archive_hash}\"#" \
  "$file"
