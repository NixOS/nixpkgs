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
, llvmPackages_15, llvm_15
} @ args:

import ./default.nix {
  rustcVersion = "1.69.0";
  rustcSha256 = "sha256-+wWXGGetbMq703ICefWpS5n2ECSSMYe1a7XEVfo89g8=";

  llvmSharedForBuild = pkgsBuildBuild.llvmPackages_15.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForHost = pkgsBuildHost.llvmPackages_15.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForTarget = pkgsBuildTarget.llvmPackages_15.libllvm.override { enableSharedLibraries = true; };

  llvmBootstrapForDarwin = llvmPackages_11;

  # For use at runtime
  llvmShared = llvm_15.override { enableSharedLibraries = true; };

  # Expose llvmPackages used for rustc from rustc via passthru for LTO in Firefox
  llvmPackages = llvmPackages_15;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.68.2";

  # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "a85e1aa0831e8bd31dc8ba3e042b6dea69b4d45fd5d1111bf6fd2cc9d58dd619";
    x86_64-unknown-linux-gnu = "df7c7466ef35556e855c0d35af7ff08e133040400452eb3427c53202b6731926";
    x86_64-unknown-linux-musl = "bd02cbdedb4b7f2169a68dc8410e8436fab3734a3a30cab81ab21661d70c6ddd";
    arm-unknown-linux-gnueabihf = "a5847f9bcbb1fb4183656b1b01e191d8e48c7bc8346ec6831318b697a2f305c6";
    armv7-unknown-linux-gnueabihf = "f87e4b063b5f916b4a5057e5f544f819cee9ab5da3fe1a977cddb2170e7ba0d7";
    aarch64-unknown-linux-gnu = "b24d0df852490d80791a228f18c2b75f24b1e6437e6e745f85364edab245f7fa";
    aarch64-unknown-linux-musl = "e6615e72aaa3e3c9c42c35139ab253a9b738a4eab719e3e306e25026c1aa93e5";
    x86_64-apple-darwin = "632540d3d83758cb048dc45fcfbc0b29f6f170161a3051be22b0a2962a566fb9";
    aarch64-apple-darwin = "ab4c6add94686a0392953c588c2b61d4c03f51e855232d161dc492f286e34202";
    powerpc64le-unknown-linux-gnu = "cf95658277d71bb8ae3a0fbc53099cc1397ed40e0953c026f41cde4a9619efca";
    riscv64gc-unknown-linux-gnu = "befcf2d53e35ae3fe0d609d1e056bdc814bd36ce54028b8d6b8b9e38c0afcaa5";
    mips64el-unknown-linux-gnuabi64 = "ee85bbfdc2fb831f067fda19881e6427c8c86571ebff16c1bd219d850969ef0a";
  };

  selectRustPackage = pkgs: pkgs.rust_1_69;

  rustcPatches = [ ];
}

(builtins.removeAttrs args [ "pkgsBuildHost" "llvmPackages_11" "llvmPackages_15" "llvm_15"])
