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
  rustcVersion = "1.62.0";
  rustcSha256 = "09y06qmh7ihi9kgimpp3h4nj3cmgc1zypqyaba10dlk4kf07h23x";

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
  bootstrapVersion = "1.61.0";

  # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "b15eb0ad44b7253e0b5b1a8cd285feb10e9fb0402840dba9a13112c3349a4b39";
    x86_64-unknown-linux-gnu = "066b324239d30787ce64142d7e04912f2e1850c07db3b2354d8654e02ff8b23a";
    x86_64-unknown-linux-musl = "0904f6b769ae28c259e0e25a41e99290a4ae2a36bca63ae153790b2ebbc427bf";
    arm-unknown-linux-gnueabihf = "cc32705cd1b583aaac74e6663f71392131dc0355a0f484cb56f0378b71ea7ebc";
    armv7-unknown-linux-gnueabihf = "2782ec75ea4abb402513e2e57becc6c14e67b492d57228cddedef6db0853b165";
    aarch64-unknown-linux-gnu = "261cd47bc3c98c9f97b601d1ad2a7d9b33c9ea63c9a351119c2f6d4e82f5d436";
    aarch64-unknown-linux-musl = "feb79985cb161a10b252236852df8db3bf3593c78905b84c7e94cd4454327e47";
    x86_64-apple-darwin = "d851f1a473926a5d8f111ed08002047a5dc4ad944a5b7f8d5d2f1f266b51e66a";
    aarch64-apple-darwin = "2dbafd13d007543aada47179fa273f9a3865f27e0a07bd69be61801232a0819e";
    powerpc64le-unknown-linux-gnu = "6d5cd579b68a2adc20384406c69a92beaaf4941056e126ff0ed1ec2f3a4e721f";
    riscv64gc-unknown-linux-gnu = "3d0f3b1a8522e09fffdf920a061794ac3107410eb1fe8f5d62a7aae3c6dcb81e";
    mips64el-unknown-linux-gnuabi64 = "6ed5b6492e68f45488108abd06dbcd4b89c46cdbd4715331bb11e88f18500815";
  };

  selectRustPackage = pkgs: pkgs.rust_1_62;

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "pkgsBuildHost" "llvmPackages_11" "llvmPackages_14" "llvm_14"])
