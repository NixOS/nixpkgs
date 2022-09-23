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
  rustcVersion = "1.63.0";
  rustcSha256 = "1l4rrbzhxv88pnfq94nbyb9m6lfnjwixma3mwjkmvvs2aqlq158z";

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
  bootstrapVersion = "1.62.1";

  # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "1669163ffe01e252ffb62da7d84949378fc274931a65ac827d54059a5ffc542c";
    x86_64-unknown-linux-gnu = "dd7d82b8fa8eae59729e1c31fe59a9de6ee61d08ab40ce016185653beebe04d2";
    x86_64-unknown-linux-musl = "32bee487074b105e2582cddce35934a6019eec74bae3f9300fdc3edfcf5b66d4";
    arm-unknown-linux-gnueabihf = "5c735e8174d394936d7b499c2d147ddadf3c4d77e652d1e0b0a72d9d09f81ea4";
    armv7-unknown-linux-gnueabihf = "26fa731385f1a71211ba8e3c94f3bb3b1a82bde89f8d4dcf75b4b463b57b0f88";
    aarch64-unknown-linux-gnu = "1311fa8204f895d054c23a3481de3b158a5cd3b3a6338761fee9cdf4dbf075a5";
    aarch64-unknown-linux-musl = "73bbab4d8a9e3c416035d40406e656ab37e785df35fa069a33af52e931a24b12";
    x86_64-apple-darwin = "0a04dcf2b521239826f3eaa66d77169d91e68087ccc3107b54e8aba7c02c9adf";
    aarch64-apple-darwin = "6d1671ea31b05cab5e2587cc2b295b3e7232b0135f0977355618e2a01933ff0a";
    powerpc64le-unknown-linux-gnu = "1d3248e1a673cda87cf443cd4334ff5fb53e6f87c72d3587b07e5c0cb507f3ae";
    riscv64gc-unknown-linux-gnu = "fd378d0bf866689e8111aba0e2b020da87f32f70fb11d98a575d42dc05978c2a";
    mips64el-unknown-linux-gnuabi64 = "b7c47dd94728161aa96762fb7bc51b6ab0feba7c5215d06eaea5b78649815a96";
  };

  selectRustPackage = pkgs: pkgs.rust_1_63;

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "pkgsBuildHost" "llvmPackages_11" "llvmPackages_14" "llvm_14"])
