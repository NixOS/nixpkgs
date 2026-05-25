#!/usr/bin/env nix-shell
#!nix-shell -i bash --keep GITHUB_TOKEN -p curl jq nix

set -euo pipefail

cd $(readlink -e $(dirname "${BASH_SOURCE[0]}"))

repos=("LxgwNeoZhiSong" "LxgwNeoXiHei" "LxgwNeoXiZhi-Screen" "LxgwXiHei" "LxgwZhiSong")

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
                select(.name | endswith(".ttf"))
                | {
                    key: .name | rtrimstr(".ttf"),
                    value: { url: .browser_download_url, sha256: (.digest | split(":")[1]) }
                  }
              )
            | from_entries
          )
        }
      }
    ' <<<"$latest_release_info"
  done

  neoxihei_code_version=$(curl -s ${GITHUB_TOKEN:+ -H "Authorization: Bearer $GITHUB_TOKEN"} https://api.github.com/repos/lxgw/NeoXiHei-Code/releases/latest | jq -r '.tag_name')
  neoxihei_code_url="https://raw.githubusercontent.com/lxgw/NeoXiHei-Code/refs/tags/${neoxihei_code_version}/NeoXiHeiCode-Regular.ttf"
  neoxihei_code_hash=$(nix-prefetch-url --name "NeoXiHeiCode-Regular-${neoxihei_code_version}" "$neoxihei_code_url")
  neoxihei_code_hash=$(nix-hash --to-sri --type sha256 "$neoxihei_code_hash")

  cat <<EOF
{
  "NeoXiHei-Code": {
    "version": "$neoxihei_code_version",
    "sources": {
      "NeoXiHeiCode-Regular": {
        "url": "$neoxihei_code_url",
        "hash": "$neoxihei_code_hash"
      }
    }
  }
}
EOF
} | jq -s 'add' > "sources.json"
