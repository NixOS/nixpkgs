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
  rustcVersion = "1.61.0";
  rustcSha256 = "1vfs05hkf9ilk19b2vahqn8l6k17pl9nc1ky9kgspaascx8l62xd";

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
  bootstrapVersion = "1.60.0";

  # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "2a635269dc9ad8f7bbdf168cdf120e1ec803d36adc832c0804f38e0acc3e2357";
    x86_64-unknown-linux-gnu = "b8a4c3959367d053825e31f90a5eb86418eb0d80cacda52bfa80b078e18150d5";
    x86_64-unknown-linux-musl = "f0feefcb1985c5c894ad9b0f44e6f09900b31c0eb5f49827da9f37d332a63894";
    arm-unknown-linux-gnueabihf = "161b2b97d4512080350cc6656b0765ebae870335e86c2896bed08b32c66fbdf4";
    armv7-unknown-linux-gnueabihf = "f2d76e9458949675bab8fcae44f600d30d91f62bf93c127b6b1fe3130e67d5d9";
    aarch64-unknown-linux-gnu = "99c419c2f35d4324446481c39402c7baecd7a8baed7edca9f8d6bbd33c05550c";
    aarch64-unknown-linux-musl = "fe7e9bad8beea84973f7ffa39879929de4ac8afad872650fb0af6b068f05faa6";
    x86_64-apple-darwin = "0b10dc45cddc4d2355e38cac86d71a504327cb41d41d702d4050b9847ad4258c";
    aarch64-apple-darwin = "b532672c278c25683ca63d78e82bae829eea1a32308e844954fb66cfe34ad222";
    powerpc64le-unknown-linux-gnu = "80125e90285b214c2b1f56ab86a09c8509aa17aec9d7127960a86a7008e8f7de";
    riscv64gc-unknown-linux-gnu = "9cc7c6804bcbbecb9c35232035fc488dbcc8487606cc6be3da553cc446bf0fcd";
    mips64el-unknown-linux-gnuabi64 = "d413681c22511259f7cd15414a00050cf151d46ac0f9282e765faeb86688deac";
  };

  selectRustPackage = pkgs: pkgs.rust_1_61;

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "pkgsBuildHost" "llvmPackages_11" "llvmPackages_14" "llvm_14"])
