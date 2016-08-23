#! /usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils findutils gnused nix wget

set -x

MAJOR_VERSION="5.5"
VERSION="${MAJOR_VERSION}.1"
# The trailing slash at the end is necessary!
RELEASE_URLS=(
    "http://download.qt.io/official_releases/qt/$MAJOR_VERSION/$VERSION/submodules/"
    "http://download.qt.io/community_releases/$MAJOR_VERSION/$VERSION/"
)
EXTRA_WGET_ARGS='-A *.tar.xz'

mkdir tmp; cd tmp

for url in "${RELEASE_URLS[@]}"; do
    wget -nH -r -c --no-parent $url $EXTRA_WGET_ARGS
done

cat >../srcs.nix <<EOF
# DO NOT EDIT! This file is generated automatically by fetchsrcs.sh
{ fetchurl, mirror }:

{
EOF

workdir=$(pwd)

find . | sort | while read src; do
    if [[ -f "${src}" ]]; then
        url="${src:2}"
        # Sanitize file name
        filename=$(basename "$src" | tr '@' '_')
        nameversion="${filename%.tar.*}"
        name=$(echo "$nameversion" | sed -e 's,-[[:digit:]].*,,' | sed -e 's,-opensource-src$,,')
        version=$(echo "$nameversion" | sed -e 's,^\([[:alpha:]][[:alnum:]]*-\)\+,,')
        sha256=$(nix-hash --type sha256 --base32 --flat "$src")
        cat >>../srcs.nix <<EOF
  $name = {
    version = "$version";
    src = fetchurl {
      url = "\${mirror}/$url";
      sha256 = "$sha256";
      name = "$filename";
    };
  };
EOF
    fi
done

echo "}" >>../srcs.nix

cd ..
