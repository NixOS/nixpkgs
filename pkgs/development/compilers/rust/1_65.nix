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
  rustcVersion = "1.65.0";
  rustcSha256 = "sha256-WCi7Z/Z36r+MOEAgWCsM56+IThyEOJSE9/jQDdgsADg=";

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
  bootstrapVersion = "1.64.0";

  # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "177b4f95c8cdaa34bb29e69950cbfe236e123757078af4792779c43ee3818199";
    x86_64-unknown-linux-gnu = "a893977f238291370ab96726a74b6b9ae854dc75fbf5730954d901a93843bf9b";
    x86_64-unknown-linux-musl = "d5c4293a8fe1b34d857bec4124229c39711f8759aa2f6108c8b6c22a308f96bb";
    arm-unknown-linux-gnueabihf = "0d7c9c746f7b98f1f99e4cf720f9a32b2f5cdf22cb1d9f677b41c1dca62f14f8";
    armv7-unknown-linux-gnueabihf = "0be29740f565ca8835ba260691274585733a7f4130ec872bfa37654a08013828";
    aarch64-unknown-linux-gnu = "7d8860572431bd4ee1b9cd0cd77cf7ff29fdd5b91ed7c92a820f872de6ced558";
    aarch64-unknown-linux-musl = "9e7cfd960fb8ad3e1f51ef667c56032d3d4d9d9f573a06bbcf65a7c7a96ab430";
    x86_64-apple-darwin = "b6003d49fb857ff8dc105a3ccba98b851cd3e7d874005acb92284fd1113adc0d";
    aarch64-apple-darwin = "e1a37dc5991304716e260144311fd291d8fb514042e45c244c582b3454477038";
    powerpc64le-unknown-linux-gnu = "9d4591033eac22093d107991a68fffccea087b26bb54115d46cc544fbf5ef66c";
    riscv64gc-unknown-linux-gnu = "f63981d9c1057cb20cf30871757d42475a1cd0c187b3dcce5fabb0cce0f80c5b";
    mips64el-unknown-linux-gnuabi64 = "47488e4c53cca5c99b5837474a880f6c2368a7fe8368560dd8077bddb94959b5";
  };

  selectRustPackage = pkgs: pkgs.rust_1_65;

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "pkgsBuildHost" "llvmPackages_11" "llvmPackages_14" "llvm_14"])
