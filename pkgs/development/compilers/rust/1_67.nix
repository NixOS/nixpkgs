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
, fetchpatch
} @ args:

import ./default.nix {
  rustcVersion = "1.67.0";
  rustcSha256 = "sha256-0CnxT85Foux6mmBdKgpAquRznLL9rinun3pukCWn/eQ=";

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
  bootstrapVersion = "1.66.1";

  # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "823128f64e902ee8aff61488c552c983e17ccca10c3f46dd93fde924d5100eb3";
    x86_64-unknown-linux-gnu = "7ecf79e9ea23d05917b0172f9f81fb1e47011d261a719998f8d5620a1e835023";
    x86_64-unknown-linux-musl = "70b660148238b8a137c6f165b0bc7bdcb50204c22a314bed6174ecd672f02e57";
    arm-unknown-linux-gnueabihf = "12c93efe71f3334ef6e718786f6a60b9566f097d23a7f1e8f38ed9add209126f";
    armv7-unknown-linux-gnueabihf = "f43c8cd3fd7d1c1e08bd6317220b2ec9b25891f464604f80bb17985b09bbf62a";
    aarch64-unknown-linux-gnu = "84b8a79803c1b91386460fe6a7d04c54002344452ff8e5c5631d5fa275ed0c9c";
    aarch64-unknown-linux-musl = "b2665da33efd328cff192a67ad026ea84f9deab8d1971892f4bbc22647606163";
    x86_64-apple-darwin = "0fcf341db2579aa6eb61a3430cd1dbc79b042dfe89686b93cc887d818d086c30";
    aarch64-apple-darwin = "03469fcaa0d8c505e6db03c18ded73cfbb6a2ce159292f8cf06c042bfc9f7cf9";
    powerpc64le-unknown-linux-gnu = "ccf915a0137bb83a9d9b133a234ae53cc099f2ba26e3cb09d209b47bbee2ade7";
    riscv64gc-unknown-linux-gnu = "525cb05edaf3ed0560753b413c72dd1b06492df28bf3c427a66fda683fdca3fc";
    mips64el-unknown-linux-gnuabi64 = "3c241cc80410fe389e8b04beda62c42496c225fe8776db9d55a498c53244f7a6";
  };

  selectRustPackage = pkgs: pkgs.rust_1_67;

  rustcPatches = [
    # fix thin archive reading
    # https://github.com/rust-lang/rust/pull/107360
    (fetchpatch {
      name = "revert-back-to-llvmarchivebuilder-on-all-platforms.patch";
      url = "https://github.com/rust-lang/rust/commit/de363d54c40a378717881240e719f5f7223ba376.patch";
      hash = "sha256-3Xb803LZUZ1dldxGJ65Iw6gg1V1K827OB/0b32GqilU=";
    })

    # Fixes ICE.
    # https://github.com/rust-lang/rust/pull/107688
    (fetchpatch {
      name = "re-erased-regions-are-local.patch";
      url = "https://github.com/rust-lang/rust/commit/9d110847ab7f6aef56a8cd20cb6cea4fbcc51cd9.patch";
      excludes = [ "*tests/*" ];
      hash = "sha256-EZH5K1BEOOfi97xZr1xEHFP4jjvJ1+xqtRMvxBoL8pU=";
    })
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "pkgsBuildHost" "llvmPackages_11" "llvmPackages_15" "llvm_15"])
