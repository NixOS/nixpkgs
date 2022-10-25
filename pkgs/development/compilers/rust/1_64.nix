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
, CoreFoundation, Security, SystemConfiguration
, pkgsBuildTarget, pkgsBuildBuild, pkgsBuildHost
, makeRustPlatform
, llvmPackages_11
, llvmPackages_14, llvm_14
} @ args:

import ./default.nix {
  rustcVersion = "1.64.0";
  rustcSha256 = "sha256-s82fSB4aKQG/bzgI0wxpzE6oDZPEzE4u1SJYsYA4EgU=";

  llvmSharedForBuild = pkgsBuildBuild.llvmPackages_14.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForHost = pkgsBuildHost.llvmPackages_14.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForTarget = pkgsBuildTarget.llvmPackages_14.libllvm.override { enableSharedLibraries = true; };

  llvmBootstrapForDarwin = llvmPackages_11;

  # For use at runtime
  llvmShared = llvm_14.override { enableSharedLibraries = true; };

  # Expose llvmPackages used for rustc from rustc via passthru for LTO in Firefox
  llvmPackages = llvmPackages_14;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.63.0";

  # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "6ac6ca18f119e099749d67c6dc25ce3f70542b43cc05062d5138fc1052e44c54";
    x86_64-unknown-linux-gnu = "536bcf16807a4ff49b7b29af6e573a2f1821055bfad72c275c60e56edc693984";
    x86_64-unknown-linux-musl = "4516f1fa2a0d9ec9176cc734e5faaa0a3d439bd49f75553a484b6c3c6d7905ab";
    arm-unknown-linux-gnueabihf = "8847d8482e1d5ec962e092a63c95618dc7e17a079a9bf58bec1da39cac0ba4ce";
    armv7-unknown-linux-gnueabihf = "d9227bf6d93f49889c698d35adc7ab3e042988740b9d9d9c81fb54fc0f854474";
    aarch64-unknown-linux-gnu = "26745b57500da293a8147122a5998926301350a610c164f053107cbe026d3a51";
    aarch64-unknown-linux-musl = "8fee65f2bd7e010259763939cbef8ed0794773ec8959c5ef90273cf39dcba180";
    x86_64-apple-darwin = "37f76a45b8616e764c2663850758ce822c730e96af60168a46b818f528c1467d";
    aarch64-apple-darwin = "25c3f43459da9b8683292999c3522d88980b0ca3244fe830f5a87a8092aac5a6";
    powerpc64le-unknown-linux-gnu = "781662048caa48b78540c2fb22f0aa7c06d6d8e81aede0f6ef900c11428056cf";
    riscv64gc-unknown-linux-gnu = "a7f398b45229c5cca833f75421c32897174e365fbbdf78e19b87612736c918aa";
    mips64el-unknown-linux-gnuabi64 = "19f04c576c9d6b171acba65cfe44edcbcf6134a75a853d2f1538fdb2128ec654";
  };

  selectRustPackage = pkgs: pkgs.rust_1_64;

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "pkgsBuildHost" "llvmPackages_11" "llvmPackages_14" "llvm_14"])
