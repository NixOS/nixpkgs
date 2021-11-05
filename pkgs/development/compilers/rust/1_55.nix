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
, llvmPackages_12, llvm_12
} @ args:

import ./default.nix {
  rustcVersion = "1.55.0";
  rustcSha256 = "07l28f7grdmi65naq71pbmvdd61hwcpi40ry7kp7dy7m233rldxj";

  llvmSharedForBuild = pkgsBuildBuild.llvmPackages_12.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForHost = pkgsBuildHost.llvmPackages_12.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForTarget = pkgsBuildTarget.llvmPackages_12.libllvm.override { enableSharedLibraries = true; };

  llvmBootstrapForDarwin = llvmPackages_11;

  # For use at runtime
  llvmShared = llvm_12.override { enableSharedLibraries = true; };

  # Expose llvmPackages used for rustc from rustc via passthru for LTO in Firefox
  llvmPackagesForBuild = pkgsBuildBuild.llvmPackages_12;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.54.0";

  # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "1cd06090463711d50d98374ef52c1a84b9f4e3e35febaaef4890fb10536ceb3a";
    x86_64-unknown-linux-gnu = "350354495b1d4b6dd2ec7cf96aa9bc61d031951cf667a31e8cf401dc508639e6";
    x86_64-unknown-linux-musl = "3571db0018fcd32f3b579a32b2301826dbd1cce44b373aed8e8a31c2a6f52fe8";
    arm-unknown-linux-gnueabihf = "77f4e4c2195f75466c6de0b1d8fd7fb8cef3d12666e3aae777dcfd0d71d080ca";
    armv7-unknown-linux-gnueabihf = "dd01ccb6a53d5e895a6755a78c213ae601a347366688941d5c543b5af5835d6d";
    aarch64-unknown-linux-gnu = "33a50c5366a57aaab43c1c19e4a49ab7d8ffcd99a72925c315fb1f9389139e6f";
    aarch64-unknown-linux-musl = "49d94116a357ea13f5a3231de2472f59210028c3cf81f158b8a367c3155ac544";
    x86_64-apple-darwin = "5eb27a4f5f7a4699bc70cf1848e340ddd74e151488bfcb26853fd584958e3d33";
    aarch64-apple-darwin = "801b3b15b992b0321261de8b8ea2728e9a74822c6cb99bf978b34e217c7825ba";
    powerpc64le-unknown-linux-gnu = "67cadf7ac5bd2e3d5fb4baede69846059f17c4e099f771329b266d08b875ed71";
    riscv64gc-unknown-linux-gnu = "6113a6cce3500033d0dc0d170b54c5f22562ef3025fd58d804c822a2499c74d7";
  };

  selectRustPackage = pkgs: pkgs.rust_1_55;

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "pkgsBuildHost" "llvmPackages_11" "llvmPackages_12" "llvm_12"])
