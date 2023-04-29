#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils-full curl jq nix-prefetch-git

# Generates a file containing a Nix function that can be used for skia depSrcs.
# For example:
#   ./make-deps.sh 'angle2|dng_sdk|piex|sfntly' chrome/m102

set -e

FILTER=$1
REVISION=$2
OUT="skia-deps-${REVISION##*/}.nix"
DEPS=$(curl -s https://skia.googlesource.com/skia/+/$REVISION/DEPS?format=TEXT | base64 --decode)
THIRD_PARTY_DEPS=$(echo "$DEPS" | grep third_party | grep "#" -v | sed 's/"//g')

function write_fetch_defs ()
{
  while read -r DEP; do
    NAME=$(echo "$DEP" | cut -d: -f1 | cut -d/ -f3 | sed 's/ //g')
    URL=$(echo "$DEP" | cut -d: -f2- | cut -d@ -f1 | sed 's/ //g')
    REV=$(echo "$DEP" | cut -d: -f2- | cut -d@ -f2 | sed 's/[ ,]//g')

    echo "Fetching $NAME@$REV"
    PREFETCH=$(nix-prefetch-git --rev "$REV" "$URL")

(
cat <<EOF
  $NAME = fetchgit {
    url = "$URL";
    rev = "$REV";
    sha256 = $(echo $PREFETCH | jq '.sha256');
  };
EOF
) >> "$OUT"

  echo "----------"
  echo
  done <<< "$1"
}

echo "{ fetchgit }:" > "$OUT"
echo "# $0 '$FILTER' $REVISION" >> "$OUT"
echo "{" >> "$OUT"
write_fetch_defs "$(echo "$THIRD_PARTY_DEPS" | grep -E "$FILTER")"
echo "}" >> "$OUT"
