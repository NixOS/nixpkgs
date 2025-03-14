#!/usr/bin/env nix-shell
#! nix-shell -i bash -p common-updater-scripts fd jq

set -eou pipefail

OWNER="cucumber-sp"
REPO="yandex-music-linux"
URL="https://api.github.com/repos/$OWNER/$REPO"
RAW="https://raw.githubusercontent.com/$OWNER/$REPO"

latest_release="$(curl --silent "$URL/releases/latest")"
latest_tag="$(curl --silent "$URL/tags?per_page=1")"
commit_hash="$(jq -r '.[0].commit.sha' <<<"$latest_tag")"
tag=$(jq -r '.tag_name' <<<"$latest_release")
# drop 'v' prefix
version="${tag#v}"

date=$(jq -r '.created_at' <<<"$latest_release")
# truncate time
date=${date%T*}

# update version; otherwise fail
update-source-version yandex-music "$version" --ignore-same-hash

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
