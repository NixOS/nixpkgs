#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl yq
set -eu -o pipefail

target="$(dirname "$(readlink -f "$0")")/package.nix"
host="https://data.trezor.io"
metadata_aarch64=$(curl "$host/suite/releases/desktop/latest/latest-linux-arm64.yml")
metadata_x64=$(curl "$host/suite/releases/desktop/latest/latest-linux.yml")
hash_aarch64=$(echo "$metadata_aarch64" | yq .sha512 -r)
hash_x64=$(echo "$metadata_x64" | yq .sha512 -r)
version=$(echo "$metadata_x64" | yq .version -r)

sed -i "s@version = .*;@version = \"$version\";@g" "$target"
sed -i "s@aarch64-linux = \"sha512.*@aarch64-linux = \"sha512-$hash_aarch64\";@" "$target"
sed -i "s@x86_64-linux = \"sha512.*@x86_64-linux = \"sha512-$hash_x64\";@" "$target"
