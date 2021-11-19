#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-prefetch-scripts
# shellcheck shell=bash

set -eou pipefail

version=$1

bucket="https://download.pytorch.org/libtorch"
CUDA_VERSION=cu113

url_and_key_list=(
  "x86_64-darwin-cpu $bucket/cpu/libtorch-macos-${version}.zip libtorch-macos-${version}.zip"
  "x86_64-linux-cpu $bucket/cpu/libtorch-cxx11-abi-shared-with-deps-${version}%2Bcpu.zip libtorch-cxx11-abi-shared-with-deps-${version}-cpu.zip"
  "x86_64-linux-cuda $bucket/${CUDA_VERSION}/libtorch-cxx11-abi-shared-with-deps-${version}%2B${CUDA_VERSION}.zip libtorch-cxx11-abi-shared-with-deps-${version}-${CUDA_VERSION}.zip"
)

hashfile="binary-hashes-$version.nix"
echo "  \"$version\" = {" >> $hashfile

for url_and_key in "${url_and_key_list[@]}"; do
  key=$(echo "$url_and_key" | cut -d' ' -f1)
  url=$(echo "$url_and_key" | cut -d' ' -f2)
  name=$(echo "$url_and_key" | cut -d' ' -f3)

  echo "prefetching ${url}..."
  hash=$(nix hash to-sri --type sha256 $(nix-prefetch-url --unpack "$url" --name "$name"))

  echo "    $key = {" >> $hashfile
  echo "      name = \"$name\";" >> $hashfile
  echo "      url = \"$url\";" >> $hashfile
  echo "      hash = \"$hash\";" >> $hashfile
  echo "    };" >> $hashfile

  echo
done

echo "  };" >> $hashfile
echo "done."
