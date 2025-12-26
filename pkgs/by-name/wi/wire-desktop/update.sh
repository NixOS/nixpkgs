#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq

set -e

cd $1

releases=$(curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/wireapp/wire-desktop/releases" \
)

latest=$(jq --argjson suffix '{ "linux": ".deb", "macos": ".pkg" }' \
  --slurpfile versions versions.json '
  def platform_latest(platform):
    map(select(.tag_name | startswith(platform)))
    | max_by(.tag_name)
    | { version: .tag_name | ltrimstr(platform + "/")
      , url: .assets.[]
             | .browser_download_url
             | select(endswith($suffix.[platform]))
      };

  . as $releases
  | $versions.[] as $old
  | $old
  | with_entries( .key as $key
                  | { key: $key, value: $releases | platform_latest($key) }
                  | select(.value.version != $old.[$key].version)
                )
' <<< "$releases"
)

urlHashes=$(
  printf '{ '
  function entries () {
    local sep=''
    for url in $(jq --raw-output '.[].url' <<< "$latest"); do
      hash=$(nix-hash --to-sri --type sha256 $(nix-prefetch-url $url))
      if [ -z "$hash" ]; then
        printf 'Failed to retrieve hash for %s\n' "$url" 2>&1
      fi
      printf '%s"%s": "%s"\n' "$sep" "$url" "$hash"
      sep=', '
    done
  }
  entries
  printf '}'
)

commit=$(jq --arg versionJSON "$(printf '%s/versions.json' "$1")" \
  --slurpfile versions versions.json '
  $versions.[] as $old
  | to_entries
  | map("\(.key) \($old.[.key].version) -> \(.value.version)")
  | join(", ")
  | [ if . == ""
      then empty
      else { attrPath: "wire-desktop"
           , oldVersion: "A"
           , newVersion: "B"
           , files: [ $versionJSON ]
           , commitMessage: "wire-desktop: \(.)"
           }
      end
    ]
' <<< "$latest"
)

tempfile=$(mktemp)

updated=$(jq --argjson hashes "$urlHashes" --slurpfile versions versions.json '
  $versions.[] as $old
  | $old + map_values(with_entries(if .key == "url"
                                   then { key: "hash"
                                        , value: $hashes.[.value]
                                        }
                                   else .
                                   end
                                  )
                     )
' <<< "$latest" > $tempfile
)

mv $tempfile versions.json

printf '%s' "$commit"
exit 0
