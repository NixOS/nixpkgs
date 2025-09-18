#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq prefetch-yarn-deps nix-prefetch-github coreutils nix-update
# shellcheck shell=bash

# This script exists to update geocities version and pin prisma-engines version

set -euo pipefail
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

old_version=$(nix-instantiate --eval -A 'umami.version' default.nix | tr -d '"' || echo "0.0.1")
version=$(curl -s "https://api.github.com/repos/umami-software/umami/releases/latest" | jq -r ".tag_name")
version="${version#v}"

echo "Updating to $version"

if [[ "$old_version" == "$version" ]]; then
    echo "Already up to date!"
    exit 0
fi

nix-update --version "$version" umami

echo "Fetching geolite"
geocities_rev_date=$(curl https://api.github.com/repos/GitSquared/node-geolite2-redist/branches/master | jq -r ".commit.sha, .commit.commit.author.date")
geocities_rev=$(echo "$geocities_rev_date" | head -1)
geocities_date=$(echo "$geocities_rev_date" | tail -1 | sed 's/T.*//')

# upstream is kind enough to provide a file with the hash of the tar.gz archive
geocities_hash=$(curl -s "https://raw.githubusercontent.com/GitSquared/node-geolite2-redist/$geocities_rev/redist/GeoLite2-City.tar.gz.sha256")
geocities_hash_sri=$(nix-hash --to-sri --type sha256 "$geocities_hash")

cat <<EOF > "$SCRIPT_DIR/sources.json"
{
  "geocities": {
    "rev": "$geocities_rev",
    "date": "$geocities_date",
    "hash": "$geocities_hash_sri"
  }
}
EOF

echo "Pinning Prisma version"
upstream_src="https://raw.githubusercontent.com/umami-software/umami/v$version"

lock=$(mktemp)
curl -s -o "$lock" "$upstream_src/pnpm-lock.yaml"
prisma_version=$(grep "@prisma/engines@" "$lock" | head -n1 |  awk -F"[@']" '{print $4}')
rm "$lock"

nix-update --version "$prisma_version" umami.prisma-engines
