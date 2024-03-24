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
, llvmPackages_17, llvm_17
} @ args:

import ./default.nix {
  rustcVersion = "1.76.0";
  rustcSha256 = "sha256-nlz/Azp/DSJmgYmCrZDk0+Tvj47hcVd2xuJQc6E2wCE=";

  llvmSharedForBuild = pkgsBuildBuild.llvmPackages_17.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForHost = pkgsBuildHost.llvmPackages_17.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForTarget = pkgsBuildTarget.llvmPackages_17.libllvm.override { enableSharedLibraries = true; };

  # For use at runtime
  llvmShared = llvm_17.override { enableSharedLibraries = true; };

  # Expose llvmPackages used for rustc from rustc via passthru for LTO in Firefox
  llvmPackages = llvmPackages_17;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.75.0";

  # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "107b8d8825deab338f338b15f047829da6225bb34644790847e96f0957c6678f";
    x86_64-unknown-linux-gnu = "473978b6f8ff216389f9e89315211c6b683cf95a966196e7914b46e8cf0d74f6";
    x86_64-unknown-linux-musl = "cc6ef41aa811ab34f946fe2b4338d1107daf08642125fd566386bf45563597de";
    arm-unknown-linux-gnueabihf = "985454b6c385cb461cc8a39d2d7d55dcf6c50495033fe5d28edcc717729d8ae9";
    armv7-unknown-linux-gnueabihf = "bd876a75f72040d96be2fb882770b16b482ac0ab15d7e3ad24e6d25b7c74bcf7";
    aarch64-unknown-linux-gnu = "30828cd904fcfb47f1ac43627c7033c903889ea4aca538f53dcafbb3744a9a73";
    aarch64-unknown-linux-musl = "26b5989525b7cf623f3868a37549736e0efe1142a08f191a97e29758cc640ac4";
    x86_64-apple-darwin = "ad066e4dec7ae5948c4e7afe68e250c336a5ab3d655570bb119b3eba9cf22851";
    aarch64-apple-darwin = "878ecf81e059507dd2ab256f59629a4fb00171035d2a2f5638cb582d999373b1";
    powerpc64le-unknown-linux-gnu = "2599cdfea5860b4efbceb7bca69845a96ac1c96aa50cf8261151e82280b397a0";
    riscv64gc-unknown-linux-gnu = "7f7b73d8924d7dd24dcb2ef0da257eb48d9aed658b00fe68e8f1ade0b1ce4511";
  };

  selectRustPackage = pkgs: pkgs.rust_1_76;

  rustcPatches = [ ];
}

(builtins.removeAttrs args [ "pkgsBuildTarget" "pkgsBuildHost" "llvmPackages_17" "llvm_17"])
