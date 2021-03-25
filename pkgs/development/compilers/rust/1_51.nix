# New rust versions should first go to staging.
# Things to check after updating:
# 1. Rustc should produce rust binaries on x86_64-linux, aarch64-linux and x86_64-darwin:
#    i.e. nix-shell -p fd or @GrahamcOfBorg build fd on github
#    This testing can be also done by other volunteers as part of the pull
#    request review, in case platforms cannot be covered.
# 2. The LLVM version used for building should match with rust upstream.
#    Check the version number in the src/llvm-project git submodule in:
#    https://github.com/rust-lang/rust/blob/<version-tag>/.gitmodules
# 3. Firefox and Thunderbird should still build on x86_64-linux.

{ stdenv, lib
, buildPackages
, newScope, callPackage
, CoreFoundation, Security
, pkgsBuildTarget, pkgsBuildBuild, pkgsBuildHost
, makeRustPlatform
, llvmPackages_11, llvm_11
} @ args:

import ./default.nix {
  rustcVersion = "1.51.0";
  rustcSha256 = "0ixqkqglv3isxbvl4ldr4byrkx692wghsz3fasy1pn5kr2prnsvs";

  llvmSharedForBuild = pkgsBuildBuild.llvm_11.override { enableSharedLibraries = true; };
  llvmSharedForHost = pkgsBuildHost.llvm_11.override { enableSharedLibraries = true; };
  llvmSharedForTarget = pkgsBuildTarget.llvm_11.override { enableSharedLibraries = true; };

  llvmBootstrapForDarwin = llvmPackages_11;

  # For use at runtime
  llvmShared = llvm_11.override { enableSharedLibraries = true; };

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.50.0";

  # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "dee56dc425ed5d8e8112f26fba3060fd324c49f1261e0b7e8e29f7d9b852b09a";
    x86_64-unknown-linux-gnu = "fa889b53918980aea2dea42bfae4e858dcb2104c6fdca6e4fe359f3a49767701";
    x86_64-unknown-linux-musl = "867cbfb35f5dc9b43e230132ea9e7bfa98d471a9248e41b08ced2266e5ccd00f";
    arm-unknown-linux-gnueabihf = "1b72979244450e4047ab536448d6720699e1fae0ab1c4ade114099a3037e274b";
    armv7-unknown-linux-gnueabihf = "f1dde566c4e6ca2e1133c84170e46e566765a21894e1038e1cdc32745d7274ef";
    aarch64-unknown-linux-gnu = "1db7a4fbddc68cd29eb9bca9fa7d0d2d9e3d59ede7ddaad66222fb4336a6bacf";
    aarch64-unknown-linux-musl = "adcc6c76a8967bacb6687b565d3cf739e35fde066b03edb745b05b52fa8b5b36";
    x86_64-apple-darwin = "1bf5a7ecf6468ce1bf9fe49c8083b3f648b40c16fbfb7539d106fe28eb0e792e";
    powerpc64le-unknown-linux-gnu = "e0472589d3f9ba7ebf27f033af320e0d5cfb70222955bd8ed73ce2c9a70ae535";
  };

  selectRustPackage = pkgs: pkgs.rust_1_51;

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "pkgsBuildHost" "llvmPackages_11" "llvm_11"])
