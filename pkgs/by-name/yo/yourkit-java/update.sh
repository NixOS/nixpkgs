#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused gawk nix-prefetch

set -euo pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
NIX_DRV="$ROOT/package.nix"
if [[ ! -f "$NIX_DRV" ]]; then
  echo "ERROR: cannot find default.nix in $ROOT"
  exit 1
fi

function retrieve_latest_version () {
    curl https://www.yourkit.com/java/profiler/download/ \
        | grep -Eo '(Version|Build): ([a-z0-9#.-])+' \
        | awk '{ print $2 }' \
        | tr -d '\n' \
        | sed 's/#/-b/'
}

function calc_hash () {
    local version=$1
    local url=$2
    nix-prefetch "{ stdenv, fetchzip }:
stdenv.mkDerivation {
  pname = \"yourkit-java-source\";
  version = \"$version\";
  src = fetchzip {
    url = \"$url\";
  };
}"
}

function update_hash () {
    local arch=$1
    local version=$2
    local date=$(echo $version | sed 's/-.*//')
    local url=https://download.yourkit.com/yjp/$date/YourKit-JavaProfiler-$version-$arch.zip
    local hash=$(calc_hash $version $url)
    sed -i -e "s|^.*$arch.*=.*\"sha256-.*$|    $arch = \"$hash\";|" $NIX_DRV
}

version=$(retrieve_latest_version)
for arch in arm64 x64; do
    update_hash $arch $version
done

# Local variables:
# mode: shell-script
# eval: (sh-set-shell "bash")
# End:
