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
, targetPackages
, newScope, callPackage
, CoreFoundation, Security, SystemConfiguration
, pkgsBuildTarget, pkgsBuildBuild, pkgsBuildHost
, makeRustPlatform
, wrapRustcWith
, llvmPackages_16, llvm_16
} @ args:

import ./default.nix {
  rustcVersion = "1.75.0";
  rustcSha256 = "sha256-W3OfRbydNB4tHFcNZdI3VZHiLC0j71uKN3EaA4arwIg=";

  llvmSharedForBuild = pkgsBuildBuild.llvmPackages_16.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForHost = pkgsBuildHost.llvmPackages_16.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForTarget = pkgsBuildTarget.llvmPackages_16.libllvm.override { enableSharedLibraries = true; };

  # For use at runtime
  llvmShared = llvm_16.override { enableSharedLibraries = true; };

  # Expose llvmPackages used for rustc from rustc via passthru for LTO in Firefox
  llvmPackages = llvmPackages_16;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.74.0";

  # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "63462d63fa80647e0632ecb1dba5e802c66ca15df7b5224887e8f902a0365c31";
    x86_64-unknown-linux-gnu = "bff0dcb3da282aa2bc196cc42367e89815050772d21bac64cf56b14c8cc5a46d";
    x86_64-unknown-linux-musl = "e5af8c4c1b0de27734e5a955601343d1127ca1040323a94b19c239fb7da14b2e";
    arm-unknown-linux-gnueabihf = "a1d7eeb811eb3e8593ce21494e8639ac915f564278ba4eaba2d580c61ea15645";
    armv7-unknown-linux-gnueabihf = "fa417b4274f1e0aea34b049e496816e087b7b3295cc4893daa03b21a6d0e7b48";
    aarch64-unknown-linux-gnu = "bfc1ced9b15aa3966530d1d5282bfb222d24c476bda01d28abf724f6df0a03fd";
    aarch64-unknown-linux-musl = "8cc14ba4c7e103ca8403351da8aa6323ccdb1a40456dbac1911095a786010fe5";
    x86_64-apple-darwin = "5dc5a32e4288c4b4beeadba4037486fa814b4b75156e874e2995e2a6059415d3";
    aarch64-apple-darwin = "1b5af447922544974ebcf02b97f4d3349bff073b500cb80b1be4cd82bfe439d7";
    powerpc64le-unknown-linux-gnu = "bc448170bd59c949c3b0e67e600c71d1a52e6194797260c8ff8b8b0ecdc2c7b7";
    riscv64gc-unknown-linux-gnu = "d7374cf49348426317743f35b6ad801e554ec85f532e1aeee82f8e775736493d";
  };

  selectRustPackage = pkgs: pkgs.rust_1_75;

  rustcPatches = [ ];
}

(builtins.removeAttrs args [ "pkgsBuildTarget" "pkgsBuildHost" "llvmPackages_16" "llvm_16"])
