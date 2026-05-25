#!/usr/bin/env nix-shell
#!nix-shell -i bash --keep GITHUB_TOKEN -p curl jq

set -euo pipefail

cd $(readlink -e $(dirname "${BASH_SOURCE[0]}"))

repos=("Pengli" "LxgwZhenKai" "kose-font" "yozai-font" "LxgwBright" "LxgwBright-Code")

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
                select(.name | (endswith(".ttf") or endswith(".7z")))
                | {
                    key: .name | split(".")[0],
                    value: { url: .browser_download_url, sha256: (.digest | split(":")[1]) }
                  }
              )
            | from_entries
          )
        }
      }
    ' <<<"$latest_release_info"
  done

  fusionkai_version=$(curl -s ${GITHUB_TOKEN:+ -H "Authorization: Bearer $GITHUB_TOKEN"} https://api.github.com/repos/lxgw/FusionKai/releases/latest | jq -r '.tag_name')

  fusionkai_url="https://github.com/lxgw/FusionKai/archive/refs/tags/${fusionkai_version}.tar.gz"
  fusionkai_hash=$(nix-prefetch-url --name "FusionKai-${fusionkai_version}" "$fusionkai_url")
  fusionkai_hash=$(nix-hash --to-sri --type sha256 "$fusionkai_hash")

  fusionkai_jp_url="https://raw.githubusercontent.com/lxgw/FusionKai/refs/tags/${fusionkai_version}/FusionKaiJ-Regular.ttf"
  fusionkai_jp_hash=$(nix-prefetch-url --name "FusionKaiJ-Regular-${fusionkai_version}" "$fusionkai_jp_url")
  fusionkai_jp_hash=$(nix-hash --to-sri --type sha256 "$fusionkai_jp_hash")

  fusionkai_tc_url="https://raw.githubusercontent.com/lxgw/FusionKai/refs/tags/${fusionkai_version}/FusionKaiT-Regular.ttf"
  fusionkai_tc_hash=$(nix-prefetch-url --name "FusionKaiT-Regular-${fusionkai_version}" "$fusionkai_tc_url")
  fusionkai_tc_hash=$(nix-hash --to-sri --type sha256 "$fusionkai_tc_hash")

  marker_gothic_version=$(curl -s ${GITHUB_TOKEN:+ -H "Authorization: Bearer $GITHUB_TOKEN"} https://api.github.com/repos/lxgw/LxgwMarkerGothic/releases/latest | jq -r '.tag_name')
  marker_gothic_url="https://raw.githubusercontent.com/lxgw/LxgwMarkerGothic/refs/tags/${marker_gothic_version}/fonts/ttf/LXGWMarkerGothic-Regular.ttf"
  marker_gothic_hash=$(nix-prefetch-url --name "LXGWMarkerGothic-Regular-${marker_gothic_version}" "$marker_gothic_url")
  marker_gothic_hash=$(nix-hash --to-sri --type sha256 "$marker_gothic_hash")

  cat <<EOF
{
  "FusionKai": {
    "version": "$fusionkai_version",
    "sources": {
      "FusionKai": {
        "url": "$fusionkai_url",
        "hash": "$fusionkai_hash"
      },
      "FusionKaiJ-Regular": {
        "url": "$fusionkai_jp_url",
        "hash": "$fusionkai_jp_hash"
      },
      "FusionKaiT-Regular": {
        "url": "$fusionkai_tc_url",
        "hash": "$fusionkai_tc_hash"
      }
    }
  },
  "LxgwMarkerGothic": {
    "version": "$marker_gothic_version",
    "sources": {
      "LXGWMarkerGothic-Regular": {
        "url": "$marker_gothic_url",
        "hash": "$marker_gothic_hash"
      }
    }
  }
}
EOF
} | jq -s 'add' > "sources.json"
