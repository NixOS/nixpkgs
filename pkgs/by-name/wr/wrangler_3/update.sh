#! /usr/bin/env nix-shell
#! nix-shell -i bash -p gnused nix nodejs prefetch-npm-deps wget

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
sha256=$(nix-prefetch-url --name "$store_name" "$url")
src_hash=$(nix-hash --to-sri --type sha256 "$sha256")
sed -i 's#hash = "[^"]*"#hash = "'"$src_hash"'"#' package.nix

rm -f *.tar.gz
rm -rf "${tarball%.tar.gz}"

wget "$url"

mkdir -p "${tarball%.tar.gz}"
tar xf "$tarball" -C "${tarball%.tar.gz}"

tar xf "$tarball" -C "${tarball%.tar.gz}"

target_dir="${tarball%.tar.gz}/workers-sdk-wrangler-${version}"
npm i --save-dev --legacy-peer-deps --package-lock-only --ignore-scripts --prefix "$target_dir"
npm_hash=$(prefetch-npm-deps "${target_dir}/package-lock.json")
rm -f *.tar.gz
rm -rf "${tarball%.tar.gz}"

sed -i 's#npmDepsHash = "[^"]*"#npmDepsHash = "'"$npm_hash"'"#' package.nix

popd
