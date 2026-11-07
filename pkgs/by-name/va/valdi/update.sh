#!/usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq common-updater-scripts prefetch-npm-deps

set -eu -o pipefail

owner=snapchat
repo=valdi
path=npm_modules/cli
pkg_file=./pkgs/by-name/va/valdi/package.nix

api_url_latest="https://api.github.com/repos/$owner/$repo/commits?path=$path&per_page=1"
json_latest=$(curl -sSfL -H "Accept: application/vnd.github+json" ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "$api_url_latest")
latest_rev=$(printf '%s' "$json_latest" | jq -r '.[0].sha')

version=$(curl -sSfL "https://raw.githubusercontent.com/$owner/$repo/$latest_rev/$path/package.json" | jq -r .version)

update-source-version valdi "$version" --rev="$latest_rev"

deps_hash=$(prefetch-npm-deps <(curl -sSfL "https://raw.githubusercontent.com/$owner/$repo/$latest_rev/$path/package-lock.json"))

sed -i "s|npmDepsHash = \".*\";|npmDepsHash = \"$deps_hash\";|" "$pkg_file"
