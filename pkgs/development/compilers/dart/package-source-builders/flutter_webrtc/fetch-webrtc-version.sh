#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq curl

set +e

if ! [[ -v 1 ]] || [[ "$1" = "-h" ]] || [[ "$1" = "--help" ]]; then
  echo "usage: fetch-webrtc-version.sh <version>"
  echo '                               ~-------~'
  echo '              this should be the *flutter_webrtc* version'
  exit 1
fi

main() {
  # remove the 'v' from the version string if it's there, so v1.5.0 -> 1.5.0 but 1.6.2 -> 1.6.2
  local flutter_webrtc_version="${1#v}"

  local webrtc_ver
  webrtc_ver="$(get_libwebrtc_version "$flutter_webrtc_version")"

  echo "flutter_webrtc v$flutter_webrtc_version uses $webrtc_ver" >&2

  jq --null-input \
    --arg flutter_webrtc_ver "$flutter_webrtc_version" \
    --arg libwebrtc_version "$webrtc_ver" \
    --argjson hashes "$(get_all_libwebrtc_hashes "$webrtc_ver")" '
    {
      $flutter_webrtc_ver: {
        version: $libwebrtc_version,
        hashes: $hashes
      }
    }'
}

# args: <libwebrtc-version>
get_all_libwebrtc_hashes() {
  local version="$1"
  local platforms=(linux-x64 linux-arm64)

  # turns the various platform hashes into a big JSON object: { "linux-x64": "123...", "linux-arm64": "ABC..." }
  # stolen from: https://stackoverflow.com/a/44792751
  for plat in "${platforms[@]}"; do
    echo "\"$plat\""
    printf '"sha256-%s"\n' "$(get_libwebrtc_hash "$plat" "$version")"
  done |
  jq -n 'reduce inputs as $i ({}; . + { ($i): input })'
}

# args: <flutter_webrtc_version>
get_libwebrtc_version() {
  local version="$1"
  local url="https://raw.githubusercontent.com/flutter-webrtc/flutter-webrtc/refs/tags/v${version}/third_party/libwebrtc_version.ini"

  # (crudest possible ini parsing lol)
  curl -L "$url" | grep 'binary_version' | cut -d'=' -f2 | tr -d ' '
}

# args: <platform> <libwebrtc-version>
get_libwebrtc_hash() {
  local platform="$1"
  local version="$2"
  local url="https://github.com/webrtc-sdk/libwebrtc/releases/download/${version}/libwebrtc-${platform}-release.zip"

  local hash
  hash=$(nix-prefetch-url --unpack --name "$(basename "$url")" "$url")

  nix-hash --to-base64 --type sha256 "$hash"
}

main "$@"
