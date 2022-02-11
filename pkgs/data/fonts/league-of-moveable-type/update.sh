#!/usr/bin/env bash

SITE=https://www.theleagueofmoveabletype.com

# since there is no nice way to get all the fonts,
# this fetches the homepage and extracts their names from the html …
fonts=$(curl "$SITE" 2>/dev/null | \
            sed -ne 's/<img.*cloudfront.*images\/\(.*\)-[[:digit:]-]\..*$/\1/p')

# build an ad-hoc nixexpr list with the files & hashes
echo "["
for f in $fonts; do
    url="$SITE/$f/download"
    hash=$(nix-prefetch-url --type sha256 "$url" 2>/dev/null)
    cat <<EOF
  {
    url = "$url";
    sha256 = "$hash";
    name = "$f.zip";
  }
EOF
done
echo "]"


