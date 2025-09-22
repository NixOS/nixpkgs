#!/usr/bin/env nix-shell
#! nix-shell -i bash -p common-updater-scripts fd jq

set -eou pipefail

OWNER="cucumber-sp"
REPO="yandex-music-linux"
URL="https://api.github.com/repos/$OWNER/$REPO"
RAW="https://raw.githubusercontent.com/$OWNER/$REPO"

attrname="yandex-music"
latest_release="$(curl --silent "$URL/releases/latest")"
latest_tag="$(curl --silent "$URL/tags?per_page=1")"
commit_hash="$(jq -r '.[0].commit.sha' <<<"$latest_tag")"
tag=$(jq -r '.tag_name' <<<"$latest_release")
# drop 'v' prefix
version="${tag#v}"

date=$(jq -r '.created_at' <<<"$latest_release")
# truncate time
date=${date%T*}

importTree="(let tree = import ./.; in if builtins.isFunction tree then tree {} else tree)"

# Old version with rc part (e.g. 5.61.1rc3)
oldVersion=$(nix-instantiate --eval -E "with $importTree; $attrname.version" | tr -d '"')
# Rc part of old version (without "rc) (e.g. 3)
oldVersionRc="${oldVersion##*rc}"

# If old version does not have "rc" part - assume rc is 0
if [ "$oldVersionRc" == "$oldVersion" ]; then
  oldVersionRc="0"
fi
# Old version w/o rc part (e.g 5.61.1)
oldVersion="${oldVersion%%rc*}"
# Remove "rc" part from new version. There should be no "rc" part at all but
# better to play it safe.
version="${version%%rc*}"

rc=""

# If new version is the same as old version - increase rc and format rc part
if [ "$version" == "$oldVersion" ]; then
  rc="rc$((oldVersionRc + 1))";
fi

# update version; otherwise fail
update-source-version "$attrname" "$version$rc" --ignore-same-hash --rev="$commit_hash"

# set yandex-music dir
dir="pkgs/by-name/ya/yandex-music"

# download and save new version of 'exe' file
ym_info=$(curl --silent "$RAW/$commit_hash/utility/version_info.json" |\
    jq '.ym')

exe_name="$(jq -r '.exe_name' <<<"$ym_info")"
exe_link="$(jq -r '.exe_link' <<<"$ym_info")"
exe_sha256="$(jq -r '.exe_sha256' <<<"$ym_info")"
exe_hash="$(nix-hash --to-sri --type sha256  "$exe_sha256")"

jq '.' > "$dir/ym_info.json" <<- EOJSON ||\
        echo "Please run the script in the root of the Nixpkgs repo"
{
    "version": "$version",
    "exe_name": "$exe_name",
    "exe_link": "$exe_link",
    "exe_hash": "$exe_hash"
}
EOJSON
