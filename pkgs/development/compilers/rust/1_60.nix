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
  rustcVersion = "1.60.0";
  rustcSha256 = "1drqr0a26x1rb2w3kj0i6abhgbs3jx5qqkrcwbwdlx7n3inq5ji0";

  llvmSharedForBuild = pkgsBuildBuild.llvmPackages_14.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForHost = pkgsBuildHost.llvmPackages_14.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForTarget = pkgsBuildTarget.llvmPackages_14.libllvm.override { enableSharedLibraries = true; };

  llvmBootstrapForDarwin = llvmPackages_11;

  # For use at runtime
  llvmShared = llvm_14.override { enableSharedLibraries = true; };

  # Expose llvmPackages used for rustc from rustc via passthru for LTO in Firefox
  llvmPackagesForBuild = pkgsBuildBuild.llvmPackages_14;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.59.0";

  # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "f57ebfafed1e857b2b1dc1a22cf1133766f68a0759dc2f717dec54a8d4385dec";
    x86_64-unknown-linux-gnu = "0c1c2da3fa26372e5178123aa5bb0fdcd4933fbad9bfb268ffbd71807182ecae";
    x86_64-unknown-linux-musl = "c0ae76fa4bb0f1c85b86b9f7637db0fddf5084ce4c8f86c4d4acc3c41813201f";
    arm-unknown-linux-gnueabihf = "f934ddd8533d5df922e3397a5d30404930c5992c6c91c72d3e1475e2978e8793";
    armv7-unknown-linux-gnueabihf = "acb0f793c517de927b17e1c85135f6d58ae7430a8bd094a92009bcf0d4bbb8eb";
    aarch64-unknown-linux-gnu = "ab5da30a3de5433e26cbc74c56b9d97b569769fc2e456fc54378adc8baaee4f0";
    aarch64-unknown-linux-musl = "a3f8afdf23c98e6d25bf3b4bfcf5e9a4712f4c425f3754500931232d946204a9";
    x86_64-apple-darwin = "d82204f536af0c7bfd2ea2213dc46b99911860cfc5517f7321244412ae96f159";
    aarch64-apple-darwin = "5449ae915982967bae97746ce8bea30844f9ab40b4ee4da392b9997e0e7b2926";
    powerpc64le-unknown-linux-gnu = "6892a706ea8118344a4f4624b57a99460a784b5b30cccd9df430c33008d341f3";
    riscv64gc-unknown-linux-gnu = "e0cb22c2383d73b3928c17a630ae8d37f6787ddcea7871c9b3e21fd4560226b2";
    mips64el-unknown-linux-gnuabi64 = "2e2c404741b1dd02b5d73361f187568a91a8531997ade41bd855eca3972e2a5b";
  };

  selectRustPackage = pkgs: pkgs.rust_1_60;

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "pkgsBuildHost" "llvmPackages_11" "llvmPackages_14" "llvm_14"])
