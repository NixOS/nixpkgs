#! /usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils findutils gnused nix wget

set -x

# The trailing slash at the end is necessary!
RELEASE_URL="http://download.qt.io/official_releases/qt/5.6/5.6.0/submodules/"
EXTRA_WGET_ARGS='-A *.tar.xz'

mkdir tmp; cd tmp

wget -nH -r -c --no-parent $RELEASE_URL $EXTRA_WGET_ARGS

cat >../srcs.nix <<EOF
# DO NOT EDIT! This file is generated automatically by manifest.sh
{ fetchurl, mirror }:

{
EOF

workdir=$(pwd)

find . | while read src; do
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
