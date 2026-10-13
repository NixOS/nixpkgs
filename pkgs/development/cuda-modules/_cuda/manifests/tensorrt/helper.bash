#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nix jq

# shellcheck shell=bash

set -euo pipefail

mkRedistUrlRelativePath() {
  local -r cudaMajorMinorVersion=${1:?}
  local -r tensorrtMajorMinorPatchBuildVersion=${2:?}
  local -r redistSystem=${3:?}

  local -r tensorrtMajorMinorPatchVersion="$(echo "$tensorrtMajorMinorPatchBuildVersion" | cut -d. -f1-3)"
  local -r tensorrtMajorVersion="$(echo "$tensorrtMajorMinorPatchVersion" | cut -d. -f1)"
  local -r tensorrtMinorVersion="$(echo "$tensorrtMajorMinorPatchVersion" | cut -d. -f2)"

  local tarExtension=""
  local platformExtension=""
  case "$tensorrtMajorVersion" in
  10) tarExtension="tar.gz" && platformExtension="-gnu" ;;
  *) tarExtension="tar.zst" ;;
  esac

  local archiveDir=""
  local archiveExtension=""
  local osName=""
  local platformName=""
  case "$redistSystem" in
  linux-aarch64) archiveDir="tars" && archiveExtension="$tarExtension" && osName="l4t" && platformName="aarch64$platformExtension" ;;
  linux-sbsa)
    archiveDir="tars" && archiveExtension="$tarExtension" && platformName="aarch64$platformExtension"
    # 10.0-10.3 use Ubuntu 22.40
    # 10.4-10.6 use Ubuntu 24.04
    # 10.7+ use Linux
    case "$tensorrtMajorVersion.$tensorrtMinorVersion" in
    10.0 | 10.1 | 10.2 | 10.3) osName="Ubuntu-22.04" ;;
    10.4 | 10.5 | 10.6) osName="Ubuntu-24.04" ;;
    *) osName="Linux" ;;
    esac
    ;;
  linux-x86_64) archiveDir="tars" && archiveExtension="$tarExtension" && osName="Linux" && platformName="x86_64$platformExtension" ;;
  windows-x86_64)
    archiveExtension="zip" && platformName="win10"
    # Windows info is different for 10.0.*
    case "$tensorrtMinorVersion" in
    0) archiveDir="zips" && osName="Windows10" ;;
    *) archiveDir="zip" && osName="Windows" ;;
    esac
    ;;
  *)
    echo "mkRedistUrlRelativePath: Unsupported redistSystem: $redistSystem" >&2
    exit 1
    ;;
  esac

  case "$tensorrtMajorVersion" in
  *)
    local -r relativePath="tensorrt/$tensorrtMajorMinorPatchVersion/$archiveDir/TensorRT-Enterprise-${tensorrtMajorMinorPatchBuildVersion}-${osName}-${platformName}-cuda-${cudaMajorMinorVersion}-Release-external.${archiveExtension}"
    echo "$relativePath"
    ;;
  10)
    local -r relativePath="tensorrt/$tensorrtMajorMinorPatchVersion/$archiveDir/TensorRT-${tensorrtMajorMinorPatchBuildVersion}.${osName}.${platformName}.cuda-${cudaMajorMinorVersion}.${archiveExtension}"
    echo "$relativePath"
    ;;
  esac
}

getNixStorePath() {
  local -r relativePath=${1:?}
  local -r jsonBlob="$(nix store prefetch-file --json "https://developer.nvidia.com/downloads/compute/machine-learning/$relativePath")"
  if [[ -z $jsonBlob ]]; then
    echo "getNixStorePath: Failed to fetch jsonBlob for relativePath: $relativePath" >&2
    exit 1
  fi
  local -r storePath="$(echo "$jsonBlob" | jq -cr '.storePath')"
  echo "$storePath"
}

printOutput() {
  local -r cudaMajorMinorVersion=${1:?}
  local -r redistSystem=${2:?}
  local -r md5Hash=${3:?}
  local -r relativePath=${4:?}
  local -r sha256Hash=${5:?}
  local -r size=${6:?}

  local -r cudaVariant="cuda$(echo "$cudaMajorMinorVersion" | cut -d. -f1)"

  # Echo everything to stdout using JQ to format the output as JSON
  jq \
    --raw-output \
    --sort-keys \
    --null-input \
    --arg redistSystem "$redistSystem" \
    --arg cudaVariant "$cudaVariant" \
    --arg md5Hash "$md5Hash" \
    --arg relativePath "$relativePath" \
    --arg sha256Hash "$sha256Hash" \
    --arg size "$size" \
    '{
      $redistSystem: {
        $cudaVariant: {
          md5: $md5Hash,
          relative_path: $relativePath,
          sha256: $sha256Hash,
          size: $size
        }
      }
    }'
}

main() {
  local -r cudaMajorMinorVersion=${1:?}
  if [[ ! $cudaMajorMinorVersion =~ ^[0-9]+\.[0-9]+$ ]]; then
    echo "main: Invalid cudaMajorMinorVersion: $cudaMajorMinorVersion" >&2
    exit 1
  fi

  local -r tensorrtMajorMinorPatchBuildVersion=${2:?}
  if [[ ! $tensorrtMajorMinorPatchBuildVersion =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "main: Invalid tensorrtMajorMinorPatchBuildVersion: $tensorrtMajorMinorPatchBuildVersion" >&2
    exit 1
  fi

  local -r redistSystem=${3:?}
  case "$redistSystem" in
  linux-aarch64) ;;
  linux-sbsa) ;;
  linux-x86_64) ;;
  windows-x86_64) ;;
  *)
    echo "main: Unsupported redistSystem: $redistSystem" >&2
    exit 1
    ;;
  esac

  local -r relativePath="$(mkRedistUrlRelativePath "$cudaMajorMinorVersion" "$tensorrtMajorMinorPatchBuildVersion" "$redistSystem")"
  local -r storePath="$(getNixStorePath "$relativePath")"
  echo "main: storePath: $storePath" >&2
  local -r md5Hash="$(nix hash file --type md5 --base16 "$storePath")"
  local -r sha256Hash="$(nix hash file --type sha256 --base16 "$storePath")"
  local -r size="$(du -b "$storePath" | cut -f1)"

  printOutput "$cudaMajorMinorVersion" "$redistSystem" "$md5Hash" "$relativePath" "$sha256Hash" "$size"
}

main "$@"
