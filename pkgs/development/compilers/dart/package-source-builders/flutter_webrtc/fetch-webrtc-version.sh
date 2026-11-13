#!/usr/bin/env nix-shell
#!nix-shell -i bash -p yq-go curl

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

  cat <<EOF
{
  "$flutter_webrtc_version": {
    "version": "$webrtc_ver",
    "hashes": $(get_all_libwebrtc_hashes "$webrtc_ver")
  }
}
EOF
}

# args: <libwebrtc-version>
get_all_libwebrtc_hashes() {
  local version="$1"

  cat <<EOF
{
  "linux-x64": "sha256-$(get_libwebrtc_hash "linux-x64" "$version")",
  "linux-arm64": "sha256-$(get_libwebrtc_hash "linux-arm64" "$version")"
}
EOF
}

# args: <flutter_webrtc_version>
get_libwebrtc_version() {
  local version="$1"
  local url="https://raw.githubusercontent.com/flutter-webrtc/flutter-webrtc/refs/tags/v${version}/third_party/libwebrtc_version.ini"

  curl -L "$url" | yq --input-format ini '.libwebrtc.binary_version'
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
