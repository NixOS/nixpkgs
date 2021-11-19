#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl
# shellcheck shell=bash

set -eu

if [[ $# -lt 1 ]]; then
    echo \"usage: $0 version\" >&2
    exit 1
fi

VERSION=$1
HASHFILE=$(mktemp /tmp/dotnet.hashes.XXXXXXXX)
trap "rm -f $HASHFILE" EXIT

curl -L https://dotnetcli.blob.core.windows.net/dotnet/checksums/$VERSION-sha.txt -o $HASHFILE

ASPNETCORE_VERSION=$(grep aspnetcore-runtime- $HASHFILE | grep -- -linux-x64.tar.gz | tail -n -1 | sed -e 's:.*aspnetcore-runtime-::' -e 's:-linux-x64.tar.gz.*$::' )
ASPNETCORE_HASH_LINUX_X64=$(grep aspnetcore-runtime- $HASHFILE | grep -- -linux-x64.tar.gz | cut -d ' ' -f 1)
ASPNETCORE_HASH_LINUX_ARM64=$(grep aspnetcore-runtime- $HASHFILE | grep -- -linux-arm64.tar.gz | cut -d ' ' -f 1)
ASPNETCORE_HASH_OSX_X64=$(grep aspnetcore-runtime- $HASHFILE | grep -- -osx-x64.tar.gz | cut -d ' ' -f 1)
ASPNETCORE_HASH_OSX_ARM64=$(grep aspnetcore-runtime- $HASHFILE | grep -- -osx-arm64.tar.gz | cut -d ' ' -f 1)

RUNTIME_VERSION=$(grep dotnet-runtime- $HASHFILE | grep -- -linux-x64.tar.gz | tail -n -1 | sed -e 's:.*dotnet-runtime-::' -e 's:-linux-x64.tar.gz.*$::' )
RUNTIME_HASH_LINUX_X64=$(grep dotnet-runtime- $HASHFILE | grep -- -linux-x64.tar.gz | cut -d ' ' -f 1)
RUNTIME_HASH_LINUX_ARM64=$(grep dotnet-runtime- $HASHFILE | grep -- -linux-arm64.tar.gz | cut -d ' ' -f 1)
RUNTIME_HASH_OSX_X64=$(grep dotnet-runtime- $HASHFILE | grep -- -osx-x64.tar.gz | cut -d ' ' -f 1)
RUNTIME_HASH_OSX_ARM64=$(grep dotnet-runtime- $HASHFILE | grep -- -osx-arm64.tar.gz | cut -d ' ' -f 1)

# dotnet-sdk has multiple entries in file, but the latest is the newest
SDK_VERSION=$(grep dotnet-sdk- $HASHFILE | grep -- -linux-x64.tar.gz | tail -n -1 | sed -e 's:.*dotnet-sdk-::' -e 's:-linux-x64.tar.gz.*$::' )
SDK_HASH_LINUX_X64=$(grep dotnet-sdk- $HASHFILE | grep -- -linux-x64.tar.gz | tail -n 1 | cut -d ' ' -f 1)
SDK_HASH_LINUX_ARM64=$(grep dotnet-sdk- $HASHFILE | grep -- -linux-arm64.tar.gz | tail -n 1 | cut -d ' ' -f 1)
SDK_HASH_OSX_X64=$(grep dotnet-sdk- $HASHFILE | grep -- -osx-x64.tar.gz | tail -n 1 | cut -d ' ' -f 1)
SDK_HASH_OSX_ARM64=$(grep dotnet-sdk- $HASHFILE | grep -- -osx-arm64.tar.gz | tail -n 1 | cut -d ' ' -f 1)

V=${VERSION/./_}
MAJOR_MINOR_VERSION=${V%%.*}

echo """
  aspnetcore_${MAJOR_MINOR_VERSION} = buildAspNetCore {
    version = \"${ASPNETCORE_VERSION}\";
    sha512 = {
      x86_64-linux = \"${ASPNETCORE_HASH_LINUX_X64}\";
      aarch64-linux = \"${ASPNETCORE_HASH_LINUX_ARM64}\";
      x86_64-darwin = \"${ASPNETCORE_HASH_OSX_X64}\";
      aarch64-darwin = \"${ASPNETCORE_HASH_OSX_ARM64}\";
    };
  };

  runtime_${MAJOR_MINOR_VERSION} = buildNetRuntime {
    version = \"${RUNTIME_VERSION}\";
    sha512 = {
      x86_64-linux = \"${RUNTIME_HASH_LINUX_X64}\";
      aarch64-linux = \"${RUNTIME_HASH_LINUX_ARM64}\";
      x86_64-darwin = \"${RUNTIME_HASH_OSX_X64}\";
      aarch64-darwin = \"${RUNTIME_HASH_OSX_ARM64}\";
    };
  };

  sdk_${MAJOR_MINOR_VERSION} = buildNetSdk {
    version = \"${SDK_VERSION}\";
    sha512 = {
      x86_64-linux = \"${SDK_HASH_LINUX_X64}\";
      aarch64-linux = \"${SDK_HASH_LINUX_ARM64}\";
      x86_64-darwin = \"${SDK_HASH_OSX_X64}\";
      aarch64-darwin = \"${SDK_HASH_OSX_ARM64}\";
    };
  };
"""
