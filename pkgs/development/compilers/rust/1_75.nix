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
, newScope, callPackage
, CoreFoundation, Security, SystemConfiguration
, pkgsBuildTarget, pkgsBuildBuild, pkgsBuildHost, pkgsTargetTarget
, makeRustPlatform
, wrapRustcWith
, llvmPackages_17, llvm_17
} @ args:

import ./default.nix {
  rustcVersion = "1.75.0";
  rustcSha256 = "sha256-W3OfRbydNB4tHFcNZdI3VZHiLC0j71uKN3EaA4arwIg=";

  llvmSharedForBuild = pkgsBuildBuild.llvmPackages_17.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForHost = pkgsBuildHost.llvmPackages_17.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForTarget = pkgsBuildTarget.llvmPackages_17.libllvm.override { enableSharedLibraries = true; };

  # For use at runtime
  llvmShared = llvm_17.override { enableSharedLibraries = true; };

  # Expose llvmPackages used for rustc from rustc via passthru for LTO in Firefox
  llvmPackages = llvmPackages_17;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.74.1";

  # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "b883b98372c91bc6aa9dc6ebb2b4e02e7dacbbc2ac1ebe55923dc37134df70a4";
    x86_64-unknown-linux-gnu = "d206888a2a9d55113940151ba16117ce2456d7de021bab18cfcb06dc48d3157c";
    x86_64-unknown-linux-musl = "5af3115a1f16431630f288821bd7f3be8cf7e08a7611b3c3bce3976774aa6cd2";
    arm-unknown-linux-gnueabihf = "1dd7d835af4afe9adb7f785046c907090ace66f1c975cfe9e8886847310d8ec9";
    armv7-unknown-linux-gnueabihf = "a5038ae004bf86eed64ef67329f7ba047bb4d188663bfd260320d53a2fed33c4";
    aarch64-unknown-linux-gnu = "0dbdfce647f3c7d9ff00a7aa5d6dbbd7010486f803a9749cff46189f5ecb438c";
    aarch64-unknown-linux-musl = "02674b8e4311780464313c5773d43606fbf6880d5c4512930d59b6d5d369f0de";
    x86_64-apple-darwin = "54e1ef01d73f6031fbee36bbecd9af4209eb682dea478696e8282ca64d5792e5";
    aarch64-apple-darwin = "af6a982cbed85807fb8e5c4ba85b8a76162b58945f4787e0a7dec32e901e8b3b";
    powerpc64le-unknown-linux-gnu = "bb1c9f0ab1016a2817afe8f72c03f8f1787fe44d0f9999669e0c1957a08e6213";
    riscv64gc-unknown-linux-gnu = "86561a8d630f634fdd7cb5899d40027103c907d9763a32770b7e2fd57dbd8473";
  };

  selectRustPackage = pkgs: pkgs.rust_1_75;

  rustcPatches = [ ];
}

(builtins.removeAttrs args [ "llvmPackages_17" "llvm_17"])
