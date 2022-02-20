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
, llvmPackages_13, llvm_13
} @ args:

import ./default.nix {
  rustcVersion = "1.58.1";
  rustcSha256 = "1iq7kj16qfpkx8gvw50d8rf7glbm6s0pj2y1qkrz7mi56vfsyfd8";

  llvmSharedForBuild = pkgsBuildBuild.llvmPackages_13.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForHost = pkgsBuildHost.llvmPackages_13.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForTarget = pkgsBuildTarget.llvmPackages_13.libllvm.override { enableSharedLibraries = true; };

  llvmBootstrapForDarwin = llvmPackages_11;

  # For use at runtime
  llvmShared = llvm_13.override { enableSharedLibraries = true; };

  # Expose llvmPackages used for rustc from rustc via passthru for LTO in Firefox
  llvmPackagesForBuild = pkgsBuildBuild.llvmPackages_13;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.57.0";

  # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "7e4ac8ca2874897099a3ceb89039ceee170f474a98ee247589fd6bca8dda7cfa";
    x86_64-unknown-linux-gnu = "ea0253784b2e5c22659ff148d492a68d2e11da734491714ebc61cc93896efcda";
    x86_64-unknown-linux-musl = "56876ebca0e46236208c8bd3c3425dba553abe49639e1040ee8b95bc66a45d33";
    arm-unknown-linux-gnueabihf = "b4448f7a96da4feee99a2c4b16b5738b99ab7e86e22d284ea6f7dca5921bca9b";
    armv7-unknown-linux-gnueabihf = "577682b1405e8901f971839407daaad06d8ae68ad370305b75d569ba293c4fb4";
    aarch64-unknown-linux-gnu = "d66847f7cf7b548ecb328c400ac4f691ee2aea6ff5cd9286ad8733239569556c";
    aarch64-unknown-linux-musl = "91c8e5171e5715261f7f635142a10a9415a4e5ba55374daf76f0b713c8b08132";
    x86_64-apple-darwin = "15ceffc4743434c19d08f73fb4edd6642b7fd8162ed7101d3e6ca2c691fcb699";
    aarch64-apple-darwin = "7511075e28b715e2d9c7ee74221779f8444681a4bb60ac3a0270a5fdf08bdd5a";
    powerpc64le-unknown-linux-gnu = "3ddc1abed6b7535c4150bf54291901fa856806c948bc21b711e24a3c8d810be7";
    riscv64gc-unknown-linux-gnu = "f809df1c6ac0adc9bd37eb871dfb0d9809f3ed7f61ba611f9305e9eb8f8c9226";
  };

  selectRustPackage = pkgs: pkgs.rust_1_58;

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "pkgsBuildHost" "llvmPackages_11" "llvmPackages_13" "llvm_13"])
