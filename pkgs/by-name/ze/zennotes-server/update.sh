#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update curl jq nix

set -euo pipefail
file="$(dirname "$0")/package.nix"
pkg="zennotes-server"

nix-update "$pkg"

version="$(nix eval --raw ".#${pkg}.version")"

manifest_json="$(curl -sSL "https://github.com/ZenNotes/znserver/releases/download/v${version}/manifest.json")"

archive_url="$(jq -r '.archive.url' <<< "$manifest_json")"
archive_sha256="$(jq -r '.archive.sha256' <<< "$manifest_json")"

sed -i \
  -e "/webArchive = fetchurl {/,/};/s#url = \"https://[^\"]*\"#url = \"${archive_url}\"#" \
  -e "/webArchive = fetchurl {/,/};/s#sha256 = \"[^\"]*\"#sha256 = \"${archive_sha256}\"#" \
  "$file"
