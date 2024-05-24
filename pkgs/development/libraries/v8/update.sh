#!/usr/bin/env nix-shell
#! nix-shell -i bash -p curl -p nix-prefetch-git -p jq
TARGET_CHANNEL=stable

set -eo pipefail

if [ -n "$1" ]; then
  v8_version="$1"
  shift
else
  chromium_version=$(curl -s "https://chromiumdash.appspot.com/fetch_releases?platform=linux&channel=${TARGET_CHANNEL}" | jq -r '.[0].version')
  v8_version=$(curl -s "https://chromiumdash.appspot.com/fetch_version?version=${chromium_version}" | jq -r '.v8_version')
fi

if [ -n "$1" ]; then
  file_path="$1"
else
  file_path=default.nix
fi

echo "Using V8 version --> $v8_version"

prefetched=$(nix-prefetch-git --no-deepClone https://chromium.googlesource.com/v8/v8 "refs/tags/${v8_version}")

path=$(echo "$prefetched" | jq -r .path)
sha256=$(echo "$prefetched" | jq -r .sha256)
sed -e "s#\\(version = \\)\"[0-9\.]*\"#\1\"$v8_version\"#" -i ${file_path}
sed -e "/v8Src = fetchgit/ { n; n; n; s/\".*\"/\"${sha256}\"/  }" -i ${file_path}

deps="$path/DEPS"

echo "$deps"

echo "Processing gn"
gn_rev=$(sed -ne "s/.*'gn_version': 'git_revision:\([^']*\).*/\1/p" < "$deps")
gn_sha256=$(nix-prefetch-git --no-deepClone https://gn.googlesource.com/gn "$gn_rev" 2>/dev/null | jq -r .sha256)
sed -e "/gnSrc = fetchgit/ { n; n; s/\".*\"/\"${gn_rev}\"/; n; s/\".*\"/\"${gn_sha256}\"/  }" -i ${file_path}

sed -ne '/" = fetchgit {/ { s/.*"\(.*\)".*/\1/; p }' < ${file_path} | while read dep; do
    echo "Processing dependency --> $dep"
    escaped_dep=$(echo "$dep" | sed -e 's#/#\\/#g')
    dep_rev=$(sed -ne "/'${escaped_dep}':/ { n; s#.*+ '##; s#'.*##;  p }" "$deps")

    if [ "$dep_rev" = "" ]; then
        echo "Failed to resolve dependency $dep, not listed in DEPS file"
        rm -f "$deps"
        exit 2
    fi

    repo_url=$(sed -ne "/\"${escaped_dep}\" = fetchgit/ { n; s/.*\"\(.*\)\".*/\1/; s#\${git_url}#https://chromium.googlesource.com#; p }"  ${file_path})
    sha256=$(nix-prefetch-git --no-deepClone "$repo_url" "$dep_rev" 2>/dev/null | jq -r .sha256)

    if [ "$sha256" = "" ]; then
        echo "Failed to get sha256 via nix-prefetch-git $repo_url $dep_rev"
        rm -f "$deps"
        exit 2
    fi

    sed -e "/\"${escaped_dep}\" = fetchgit/ { n; n; s/\".*\"/\"${dep_rev}\"/; n; s/\".*\"/\"${sha256}\"/  }" -i ${file_path}
done

echo done.
