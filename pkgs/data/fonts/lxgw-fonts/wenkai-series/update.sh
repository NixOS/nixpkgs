#!/usr/bin/env nix-shell
#!nix-shell -i bash --keep GITHUB_TOKEN -p curl jq

set -euo pipefail

cd $(readlink -e $(dirname "${BASH_SOURCE[0]}"))

repos=("LXGWWenKai" "LXGWWenKaiGB" "LXGWWenKaiTC" "LXGWWenKaiKR" "LXGWWenKai-Lite" "LXGWWenKaiGB-Lite" "LXGWWenKai-Screen")

{
  for repo in "${repos[@]}"; do
    latest_release_info=$(curl -s ${GITHUB_TOKEN:+ -H "Authorization: Bearer $GITHUB_TOKEN"} https://api.github.com/repos/lxgw/$repo/releases/latest)

    jq --arg repo "$repo" '
      {
        ($repo): {
          version: .tag_name,
          sources: (
            .assets
            | map(
                select(.name | (endswith(".ttf") or endswith(".tar.gz")))
                | .name as $name
                | {
                    key: (if $name | endswith(".ttf") then $name | rtrimstr(".ttf") else $repo end),
                    value: { url: .browser_download_url, sha256: (.digest | split(":")[1]) }
                  }
              )
            | from_entries
          )
        }
      }
    ' <<<"$latest_release_info"
  done
} | jq -s 'add' > "sources.json"
