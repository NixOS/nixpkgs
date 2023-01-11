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
  rustcVersion = "1.66.1";
  rustcSha256 = "sha256-WzyTOpTHIYdwXU7ikxmLq/3QlEL1k3+9aF2zqB9JWbo=";

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
  bootstrapVersion = "1.65.0";

  # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "b29869f8e2c7029150a929b2c4e26843f363846ad99253a25be6abcfa8e84f46";
    x86_64-unknown-linux-gnu = "8f754fdd5af783fe9020978c64e414cb45f3ad0a6f44d045219bbf2210ca3cb9";
    x86_64-unknown-linux-musl = "716984def5509a844c2dde1c7be42bfadeb179f751d5c1a30c9c7198c8c089cd";
    arm-unknown-linux-gnueabihf = "e27f835c16bfcb66ad022a17d5c4602899e021e483a432ca4cc2cb4ecd39e938";
    armv7-unknown-linux-gnueabihf = "5376d467a29b32cacb771e0c76dc280bd623852709e7ffd92caabab076d5475f";
    aarch64-unknown-linux-gnu = "f406136010e6a1cdce3fb6573506f00d23858af49dd20a46723c3fa5257b7796";
    aarch64-unknown-linux-musl = "4b701dc3cbac04ebf0e336cff2f4ce5fc1a1984c183226863c9ed911eb00b07e";
    x86_64-apple-darwin = "139087a3937799415fd829e5a88162a69a32c23725a44457f9c96b98e4d64a7c";
    aarch64-apple-darwin = "7ddc335bd10fc32d3039ef36248a5d0c4865db2437c8aad20a2428a6cf41df09";
    powerpc64le-unknown-linux-gnu = "3f1d0d5bb13213348dc65e373f8c412fc0a12ee55abc1c864f7e0300932fc687";
    riscv64gc-unknown-linux-gnu = "aac7067348d218faa452b4bdc735778a51570a310ad645313ec767b5d7c88492";
    mips64el-unknown-linux-gnuabi64 = "d91ed3857c5256720da890f6533684b684e880bf9006dc4e4f4181213a5c4a09";
  };

  selectRustPackage = pkgs: pkgs.rust_1_66;

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "pkgsBuildHost" "llvmPackages_11" "llvmPackages_14" "llvm_14"])
