{ writeScript, lib, curl, runtimeShell, jq, coreutils, moreutils, nix, gnused }:

writeScript "update-zephyr-sdk" ''
  #!${runtimeShell}
  PATH=${lib.makeBinPath [ jq curl nix coreutils moreutils gnused ]}

  set -euo pipefail
  set -x

  tmpDir=$(mktemp -d)
  srcJson=pkgs/by-name/ze/zephyr-sdk/src.json
  jsonPath="$tmpDir"/latest

  oldVersion=$(jq -r .version < "$srcJson")

  curl https://api.github.com/repos/zephyrproject-rtos/sdk-ng/releases/latest > "$jsonPath"

  newVersion=$(cat "$jsonPath" | jq -r .tag_name | sed s/^v//)

  if [[ "$oldVersion" == "$newVersion" ]]; then
    echo "version did not change"
    exit 0
  fi

  function getDownloadUrl() {
    platform=$1
    cat $jsonPath | jq -r ".assets[] | select(.name==\"zephyr-sdk-''${newVersion}_''${platform}.tar.xz\") | .browser_download_url"
  }

  function setJsonKey() {
    jq "$1 = \"$2\"" "$srcJson" | sponge "$srcJson"
  }

  function updatePlatform() {
    nixPlatform="$1"
    upstreamPlatform="$2"
    url=$(getDownloadUrl $upstreamPlatform)
    hash=$(nix-prefetch-url "$url" --type sha512)
    sriHash=$(nix hash to-sri --type sha512 $hash)
    setJsonKey .tar[\""$nixPlatform"\"].url "$url"
    setJsonKey .tar[\""$nixPlatform"\"].hash "$sriHash"
  }

  updatePlatform x86_64-linux linux-x86_64
  updatePlatform aarch64-linux linux-aarch64
  updatePlatform x86_64-darwin macos-x86_64
  updatePlatform aarch64-darwin macos-aarch64
  setJsonKey .version "$newVersion"
  echo "Updated to $newVersion"
''
