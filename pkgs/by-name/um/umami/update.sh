#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq prefetch-yarn-deps nix-prefetch-github coreutils

set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

old_version=$(jq -r ".version" sources.json || echo -n "0.0.1")
version=$(curl -s "https://api.github.com/repos/umami-software/umami/releases/latest" | jq -r ".tag_name")
version="${version#v}"

echo "Updating to $version"

if [[ "$old_version" == "$version" ]]; then
    echo "Already up to date!"
    exit 0
fi

echo "Fetching src"
src_hash=$(nix-prefetch-github umami-software umami --rev "v${version}" | jq -r .hash)
upstream_src="https://raw.githubusercontent.com/umami-software/umami/v$version"

lock=$(mktemp)
curl -s -o "$lock" "$upstream_src/yarn.lock"
yarn_hash=$(prefetch-yarn-deps "$lock")
yarn_hash_sri=$(nix-hash --to-sri --type sha256 "$yarn_hash")
rm "$lock"

geocities_rev_date=$(curl https://api.github.com/repos/GitSquared/node-geolite2-redist/branches/master | jq -r ".commit.sha, .commit.commit.author.date")
geocities_rev=$(echo "$geocities_rev_date" | head -1)
geocities_date=$(echo "$geocities_rev_date" | tail -1 | sed 's/T.*//')

# upstream is kind enough to provide a file with the hash of the tar.gz archive
geocities_hash=$(curl -s "https://raw.githubusercontent.com/GitSquared/node-geolite2-redist/$geocities_rev/redist/GeoLite2-City.tar.gz.sha256")
geocities_hash_sri=$(nix-hash --to-sri --type sha256 "$geocities_hash")

cat <<EOF > sources.json
{
  "version": "$version",
  "hash": "$src_hash",
  "yarnHash": "$yarn_hash_sri",
  "geocities": {
    "rev": "$geocities_rev",
    "date": "$geocities_date",
    "hash": "$geocities_hash_sri"
  }
}
EOF
