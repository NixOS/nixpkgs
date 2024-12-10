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

{
  stdenv,
  lib,
  newScope,
  callPackage,
  CoreFoundation,
  Security,
  SystemConfiguration,
  pkgsBuildTarget,
  pkgsBuildBuild,
  pkgsBuildHost,
  pkgsTargetTarget,
  makeRustPlatform,
  wrapRustcWith,
  llvmPackages_17,
  llvm_17,
}@args:

import ./default.nix
  {
    rustcVersion = "1.77.2";
    rustcSha256 = "xhRX749ZZjj928dxZ3iy9rmf8SUTo7DxOZTDvFIWOMM=";

    llvmSharedForBuild = pkgsBuildBuild.llvmPackages_17.libllvm.override {
      enableSharedLibraries = true;
    };
    llvmSharedForHost = pkgsBuildHost.llvmPackages_17.libllvm.override {
      enableSharedLibraries = true;
    };
    llvmSharedForTarget = pkgsBuildTarget.llvmPackages_17.libllvm.override {
      enableSharedLibraries = true;
    };

    # For use at runtime
    llvmShared = llvm_17.override { enableSharedLibraries = true; };

    # Expose llvmPackages used for rustc from rustc via passthru for LTO in Firefox
    llvmPackages = llvmPackages_17;

    # Note: the version MUST be one version prior to the version we're
    # building
    bootstrapVersion = "1.76.0";

    # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
    bootstrapHashes = {
      i686-unknown-linux-gnu = "4c3eefc9341b8809235e6c4fbcbc19ab52a5cbe771292c400df068c12984fa3e";
      x86_64-unknown-linux-gnu = "9d589d2036b503cc45ecc94992d616fb3deec074deb36cacc2f5c212408f7399";
      x86_64-unknown-linux-musl = "aa8568f4d262468aaf4f622bd421c5435b24454d8fbcdae48da1162962205384";
      arm-unknown-linux-gnueabihf = "7d1da067362fc64bcad198d90a61e024d5712aed76e17b28e1cd7e8ba263cc6f";
      armv7-unknown-linux-gnueabihf = "c03346d56d4a860cd3a8d2d2a7ea75c510b68204e3ad97b3770076595261c913";
      aarch64-unknown-linux-gnu = "2e8313421e8fb673efdf356cdfdd4bc16516f2610d4f6faa01327983104c05a0";
      aarch64-unknown-linux-musl = "a1d1c8ccb8ea00cfa2b79d80411b8eb22b2bef5214f86536825361e98d7c617a";
      x86_64-apple-darwin = "7bdbe085695df8e46389115e99eda7beed37a9494f6b961b45554c658e53b8e7";
      aarch64-apple-darwin = "17496f15c3cb6ff73d5c36f5b54cc110f1ac31fa09521a7991c0d7ddd890dceb";
      powerpc64le-unknown-linux-gnu = "44b3494675284d26b04747a824dc974e32fd8fd46fc0aa06a7c8ebe851332d2c";
      riscv64gc-unknown-linux-gnu = "4a9db321874fc441235b71eb8aa295fc50251305e461540b25b4eef89fb56255";
    };

    selectRustPackage = pkgs: pkgs.rust_1_77;

    rustcPatches = [ ];
  }

  (
    builtins.removeAttrs args [
      "llvmPackages_17"
      "llvm_17"
    ]
  )
