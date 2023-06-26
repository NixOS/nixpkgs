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
, llvmPackages_16, llvm_16
} @ args:

import ./default.nix {
  rustcVersion = "1.70.0";
  rustcSha256 = "sha256-sr+uAAt6UEDk7Eu8UKCfIVSBkMt1cLDtdzWDaEE70nw=";

  llvmSharedForBuild = pkgsBuildBuild.llvmPackages_16.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForHost = pkgsBuildHost.llvmPackages_16.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForTarget = pkgsBuildTarget.llvmPackages_16.libllvm.override { enableSharedLibraries = true; };

  llvmBootstrapForDarwin = llvmPackages_11;

  # For use at runtime
  llvmShared = llvm_16.override { enableSharedLibraries = true; };

  # Expose llvmPackages used for rustc from rustc via passthru for LTO in Firefox
  llvmPackages = llvmPackages_16;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.69.0";

  # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "08b2b4f58c0861f40ae159c39cc12f6d41b6858e04a43c6c0aeb36707e2971d0";
    x86_64-unknown-linux-gnu = "2ca4a306047c0b8b4029c382910fcbc895badc29680e0332c9df990fd1c70d4f";
    x86_64-unknown-linux-musl = "071cb04819b15d8801584a1395b28d0472ce99c0e716296e3c0bb4e6318cf171";
    arm-unknown-linux-gnueabihf = "64c82735b4e5606af61be0d01317da436a9590b969e503cdbd19e24636e15845";
    armv7-unknown-linux-gnueabihf = "a509f02d910041c97847e2ccc4ee908c761b7dc5b3c4715922d2b1c573a09675";
    aarch64-unknown-linux-gnu = "88af5aa7a40c8f1b40416a1f27de8ffbe09c155d933f69d3e109c0ccee92353b";
    aarch64-unknown-linux-musl = "76aaf3e4fd7b552feb2d70752c43896a960a2a7c940002f58a5c3f03d2b3c862";
    x86_64-apple-darwin = "9818dab2c3726d63dfbfde12c9273e62e484ef6d6f6e05a6431a3e089c335454";
    aarch64-apple-darwin = "36228cac303298243fb84235db87a5ecf2af49db28585a82af091caefd598677";
    powerpc64le-unknown-linux-gnu = "8ef68b77971c079dbe23b54a2cfb52da012873d96399c424bc223635306e9a58";
    riscv64gc-unknown-linux-gnu = "e1976bf7d0edb7e7789a1ad7ff8086fdb5306a932650fa8182a5d009883fa6c5";
    mips64el-unknown-linux-gnuabi64 = "c4bf3043451d6122a3845db825cbe35b5ca61a44659a00004f6cca1299ad9d72";
  };

  selectRustPackage = pkgs: pkgs.rust_1_70;

  rustcPatches = [ ];
}

(builtins.removeAttrs args [ "pkgsBuildHost" "llvmPackages_11" "llvmPackages_16" "llvm_16"])
