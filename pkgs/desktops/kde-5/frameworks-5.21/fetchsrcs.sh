#! /usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils findutils gnused nix wget

set -x

# The trailing slash at the end is necessary!
RELEASE_URL="http://download.kde.org/stable/frameworks/5.21/"
EXTRA_WGET_ARGS='-A *.tar.xz'

mkdir tmp; cd tmp

rm -f ../srcs.csv

wget -nH -r -c --no-parent $RELEASE_URL $EXTRA_WGET_ARGS

find . | while read src; do
    if [[ -f "${src}" ]]; then
        # Sanitize file name
        filename=$(basename "$src" | tr '@' '_')
        nameVersion="${filename%.tar.*}"
        name=$(echo "$nameVersion" | sed -e 's,-[[:digit:]].*,,' | sed -e 's,-opensource-src$,,')
        version=$(echo "$nameVersion" | sed -e 's,^\([[:alpha:]][[:alnum:]]*-\)\+,,')
        echo "$name,$version,$src,$filename" >>../srcs.csv
    fi
done

cat >../srcs.nix <<EOF
# DO NOT EDIT! This file is generated automatically by fetchsrcs.sh
{ fetchurl, mirror }:

{
EOF

gawk -F , "{ print \$1 }" ../srcs.csv | sort | uniq | while read name; do
    versions=$(gawk -F , "/^$name,/ { print \$2 }" ../srcs.csv)
    latestVersion=$(echo "$versions" | sort -rV | head -n 1)
    src=$(gawk -F , "/^$name,$latestVersion,/ { print \$3 }" ../srcs.csv)
    filename=$(gawk -F , "/^$name,$latestVersion,/ { print \$4 }" ../srcs.csv)
    url="${src:2}"
    sha256=$(nix-hash --type sha256 --base32 --flat "$src")
    cat >>../srcs.nix <<EOF
  $name = {
    version = "$latestVersion";
    src = fetchurl {
      url = "\${mirror}/$url";
      sha256 = "$sha256";
      name = "$filename";
    };
  };
EOF
done

echo "}" >>../srcs.nix

rm -f ../srcs.csv

cd ..
