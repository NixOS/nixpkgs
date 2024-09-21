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
latest_commit="$(curl --silent "$URL/commits/$commit_hash"'')"
commit_message="$(jq -r '.commit.message' <<<"$latest_commit")"

tag=$(jq -r '.tag_name' <<<"$latest_release")
# drop 'v' prefix
version="${tag#v}"

branch=$(jq -r '.target_commitish' <<<"$latest_release")

date=$(jq -r '.created_at' <<<"$latest_release")
# truncate time
date=${date%T*}

# update version; otherwise fail
update-source-version yandex-music "$version" --ignore-same-hash

# set yandex-music dir
dir="pkgs/by-name/ya/yandex-music"

echo -e '{
  "branch": "'"$branch"'",
  "commit_hash": "'"$commit_hash"'",
  "commit_message": "'"$commit_message"'",
  "date": "'"$date"'",
  "tag": "'"$tag"'"
}' >"$dir/info.json" || echo "Please run the script in the root of the Nixpkgs repo"

curl --silent "$RAW/$commit_hash/utility/version_info.json" |\
        jq . > "$dir/ym_info.json" ||\
        echo "Please run the script in the root of the Nixpkgs repo"
