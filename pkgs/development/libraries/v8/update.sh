#!/usr/bin/env nix-shell
#! nix-shell -i bash -p curl -p nix-prefetch-git
# shellcheck shell=bash
VERSION_OVERVIEW=https://omahaproxy.appspot.com/all?os=linux
TARGET_CHANNEL=beta
FILE_PATH=6_x.nix

set -eo pipefail

v8_version=$(curl -s "$VERSION_OVERVIEW" | awk -F "," "\$2 ~ /${TARGET_CHANNEL}/ { print \$11 }")

echo "Using V8 version --> $v8_version"
sed -e "s#\\(version = \\)\"[0-9\.]*\"#\1\"$v8_version\"#" -i ${FILE_PATH}

sha256=$(nix-prefetch-git --no-deepClone https://github.com/v8/v8.git "refs/tags/${v8_version}" \
    | sed -ne '/sha256/ { s#.*: "\(.*\)".*#\1#; p }')
sed -e "/repo = \"v8\"/ { n;n; s#\".*\"#\"${sha256}\"# }" -i ${FILE_PATH}

deps="$(mktemp)"

curl -s -o "$deps" "https://raw.githubusercontent.com/v8/v8/${v8_version}/DEPS"
echo $deps

sed -ne '/= fetchgit {/ { s/.*"\(.*\)".*/\1/; p }' < ${FILE_PATH} | while read dep; do
    echo "Processing dependency --> $dep"
    escaped_dep=$(echo "$dep" | sed -e 's#/#\\/#g')
    dep_rev=$(sed -ne "/\"v8\/${escaped_dep}\":/ { n; s#.*+ \"##; s#\".*##;  p }" "$deps")

    if [ "$dep_rev" = "" ]; then
        echo "Failed to resolve dependency $dep, not listed in DEPS file"
        rm -f "$deps"
        exit 2
    fi

    repo_url=$(sed -ne "/\"${escaped_dep}\" = fetchgit/ { n; s/.*\"\(.*\)\".*/\1/; s#\${git_url}#https://chromium.googlesource.com#; p }"  ${FILE_PATH})
    sha256=$(nix-prefetch-git --no-deepClone "$repo_url" "$dep_rev" 2>/dev/null | sed -ne '/sha256/ { s#.*: "\(.*\)".*#\1#; p }')

    if [ "$sha256" = "" ]; then
        echo "Failed to get sha256 via nix-prefetch-git $repo_url $dep_rev"
        rm -f "$deps"
        exit 2
    fi

    sed -e "/\"${escaped_dep}\" = fetchgit/ { n; n; s/\".*\"/\"${dep_rev}\"/; n; s/\".*\"/\"${sha256}\"/  }" -i ${FILE_PATH}
done

rm -f "$deps"
echo done.
