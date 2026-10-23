#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash curl jq

set -euo pipefail

LATEST_VERSION=$(curl -L -s https://download.sysdig.com/scanning/sysdig-cli-scanner/latest_version.txt)
SUPPORTED_OPERATING_SYSTEMS=("linux" "darwin")
SUPPORTED_ARCHITECTURES=("x86_64" "aarch64")
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
VERSIONS_FILE="${SCRIPT_DIR}/sysdig-cli-scanner.versions.nix"

main() {
  echo "{" > "$VERSIONS_FILE"
  echo "  version = \"${LATEST_VERSION}\";" >> "$VERSIONS_FILE"
  for os in "${SUPPORTED_OPERATING_SYSTEMS[@]}"; do
    for arch in "${SUPPORTED_ARCHITECTURES[@]}"; do
      formatted_arch=$(formatArchitectureForURL "$arch")
      download_url="https://download.sysdig.com/scanning/bin/sysdig-cli-scanner/${LATEST_VERSION}/${os}/${formatted_arch}/sysdig-cli-scanner"
      file_hash=$(fetchFileHash "$download_url")
      appendToVersionsFile "$VERSIONS_FILE" "$arch" "$os" "$download_url" "$file_hash"
    done
  done
  echo "}" >> "$VERSIONS_FILE"
}

formatArchitectureForURL() {
  local architecture="$1"
  case "$architecture" in
    x86_64) echo "amd64" ;;
    aarch64) echo "arm64" ;;
    *) echo "Unsupported architecture: $architecture" >&2; return 1 ;;
  esac
}

fetchFileHash() {
  local url="$1"
  nix store prefetch-file --json "$url" | jq -r .hash
}

appendToVersionsFile() {
  local file="$1"
  local architecture="$2"
  local operating_system="$3"
  local url="$4"
  local hash="$5"
  cat >> "$file" << EOF

  ${architecture}-${operating_system} = {
    url = "$url";
    hash = "$hash";
  };
EOF
}

main

