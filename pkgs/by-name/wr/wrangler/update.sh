#! /usr/bin/env nix-shell
#! nix-shell -i bash -p gnused nix nodejs prefetch-npm-deps wget pnpm

set -euo pipefail
pushd "$(dirname "${BASH_SOURCE[0]}")"

version=$(npm view wrangler version)
tarball="wrangler@$version.tar.gz"
url="https://github.com/cloudflare/workers-sdk/archive/refs/tags/$tarball"
if [[ "$UPDATE_NIX_OLD_VERSION" == "$version" ]]; then
    echo "Already up to date!"
    exit 0
fi
sed -i 's#version = "[^"]*"#version = "'"$version"'"#' package.nix

store_name="wrangler_$version.tar.gz"
prefetched_url=$(nix-prefetch-url --quiet --unpack --name "$store_name" "$url")
src_hash=$(nix hash to-sri --type sha256 "$prefetched_url")
sed -i 's#srcHash = "[^"]*"#srcHash = "'"$src_hash"'"#' package.nix

pnpm_hash=$(nix-build -E "with import <nixpkgs> {}; callPackage ./package.nix {}" 2>&1 | grep "got: " | awk '{print $NF}')
if [[ "${pnpm_hash}" == "" ]]; then
    echo "pnpm_hash already up to date!"
    exit 0
fi
sed -i 's#pnpmHash = "[^"]*"#pnpmHash = "'"$pnpm_hash"'"#' package.nix

popd
