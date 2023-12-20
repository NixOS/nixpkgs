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
  rustcVersion = "1.74.0";
  rustcSha256 = "sha256-iCtYS8Mhxdz+d82qafJ3kGuTYlXveAj81cdJKSXPEEk=";

  llvmSharedForBuild = pkgsBuildBuild.llvmPackages_16.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForHost = pkgsBuildHost.llvmPackages_16.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForTarget = pkgsBuildTarget.llvmPackages_16.libllvm.override { enableSharedLibraries = true; };

  # For use at runtime
  llvmShared = llvm_16.override { enableSharedLibraries = true; };

  # Expose llvmPackages used for rustc from rustc via passthru for LTO in Firefox
  llvmPackages = llvmPackages_16;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.73.0";

  # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "6a088acbbda734d27e8b431499f1d746de7781673b88fead3aeae072be1d1a5a";
    x86_64-unknown-linux-gnu = "aa4cf0b7e66a9f5b7c623d4b340bb1ac2864a5f2c2b981f39f796245dc84f2cb";
    x86_64-unknown-linux-musl = "c888457d106ccd40288ca8db1cb966b23d719c9a128daca701ecc574c53773d4";
    arm-unknown-linux-gnueabihf = "9c29bb42786aedbb16ea71564eb06068a8b01cca6c6b8857f0c37f91dfba7134";
    armv7-unknown-linux-gnueabihf = "092b32b82c602c18279d76d9a96763e85030aa62cda64c1bc73fc1f6355bb99c";
    aarch64-unknown-linux-gnu = "e54d7d886ba413ae573151f668e76ea537f9a44406d3d29598269a4a536d12f6";
    aarch64-unknown-linux-musl = "f4e9ff895aa55558777585ad4debe2ccf3c0298cb5d65db67814f62428de4a5b";
    x86_64-apple-darwin = "ece9646bb153d4bc0f7f1443989de0cbcd8989a7d0bf3b7fb9956e1223954f0c";
    aarch64-apple-darwin = "9c96e4c57328fb438ee2d87aa75970ce89b4426b49780ccb3c16af0d7c617cc6";
    powerpc64le-unknown-linux-gnu = "8fa215ee3e274fb64364e7084613bc570369488fa22cf5bc8e0fe6dc810fe2b9";
    riscv64gc-unknown-linux-gnu = "381379a2381835428b2e7a396b3046581517356b7cc851e39e385aebd5700623";
  };

  selectRustPackage = pkgs: pkgs.rust_1_74;

  rustcPatches = [ ];
}

(builtins.removeAttrs args [ "pkgsBuildTarget" "pkgsBuildHost" "llvmPackages_16" "llvm_16"])
