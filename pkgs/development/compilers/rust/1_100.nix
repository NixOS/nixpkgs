# New rust versions should first go to staging.
# Things to check after updating:
# 1. Rustc should produce rust binaries on x86_64-linux, aarch64-linux and x86_64-darwin:
#    i.e. nix-shell -p fd or @GrahamcOfBorg build fd on github
#    This testing can be also done by other volunteers as part of the pull
#    request review, in case platforms cannot be covered.
# 2. The LLVM version used for building should match with rust upstream.
#    Check the version number in the src/llvm-project git submodule in:
#    https://github.com/rust-lang/rust/blob/<version-tag>/.gitmodules

# Note: The way this is structured is:
# 1. Import default.nix, and apply arguments as needed for the file-defined function
# 2. Implicitly, all arguments to this file are applied to the function that is imported.
#    if you want to add an argument to default.nix's top-level function, but not the function
#    it instantiates, add it to the `removeAttrs` call below.
{
  stdenv,
  lib,
  newScope,
  callPackage,
  pkgsBuildTarget,
  pkgsBuildBuild,
  pkgsBuildHost,
  pkgsHostTarget,
  pkgsTargetTarget,
  makeRustPlatform,
  wrapRustcWith,
  llvmPackages_23,
  llvm,
  cargo-auditable,
  wrapCCWith,
  overrideCC,
  fetchpatch,
}@args:
let
  llvmSharedFor =
    pkgSet:
    pkgSet.llvmPackages_23.libllvm.override (
      {
        enableSharedLibraries = true;
      }
      // lib.optionalAttrs (stdenv.targetPlatform.useLLVM or false) {
        # Force LLVM to compile using clang + LLVM libs when targeting pkgsLLVM
        stdenv = pkgSet.stdenv.override {
          allowedRequisites = null;
          cc = pkgSet.pkgsBuildHost.llvmPackages_23.clangUseLLVM;
        };
      }
    );
in
import ./default.nix
  {
    rustcVersion = "1.100.1";
    rustcSha256 = "sha256-Z6blGbF3tfYss2haIAUn/A/Ghd9AozyiAX8Uuv1r9xA=";

    llvmSharedForBuild = llvmSharedFor pkgsBuildBuild;
    llvmSharedForHost = llvmSharedFor pkgsBuildHost;
    llvmSharedForTarget = llvmSharedFor pkgsBuildTarget;
    llvmPackages = llvmPackages_23;

    inherit cargo-auditable;

    # For use at runtime
    llvmShared = llvmSharedFor pkgsHostTarget;

    # Note: the version MUST be the same version that we are building. Upstream
    # ensures that each released compiler can compile itself:
    # https://github.com/NixOS/nixpkgs/pull/351028#issuecomment-2438244363
    bootstrapVersion = "1.100.1";

    # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
    bootstrapHashes = {
      i686-unknown-linux-gnu = "1b27023e907f08ffb6730f2628141afd433322dd53c52f2f2fddfc5681f04e4f";
      x86_64-unknown-linux-gnu = "0b9af2dbe8d25733adcaac2da452fbe3e43cf4300255102d20d4d1c2e386935d";
      x86_64-unknown-linux-musl = "6eaa7d05e600627ee1e8aadb219cd5ce05340a20ad2b94ebf0b2a8f6a92e6090";
      arm-unknown-linux-gnueabihf = "ea548e10c11b5086b65f496c8875d2b29fb6265b3ce468be5c3cd2c7f56f852a";
      armv7-unknown-linux-gnueabihf = "52c9e9c91d055f386cff27fb86880d0954afbc8144d1ab051207dadfbd8b875c";
      aarch64-unknown-linux-gnu = "f86f656ac30e656a306e3af48b8333fe9e9616454301714358c05a91dfd2754e";
      aarch64-unknown-linux-musl = "7eb70befcbc1d16043f2739980fd11e7f374283f3040e151bbfdb7d8e3ce1091";
      x86_64-apple-darwin = "ff43997697fd874b04bdf0fc07eeaeb849da8f311a09801a5e40a97080b1585b";
      aarch64-apple-darwin = "260b1c6e421cfb932227fad97cf3a0556c8ab85517aa1ac574e7489487c238f9";
      powerpc64-unknown-linux-gnu = "29ea8eb1cee305262972d43bd9b1b5a7220e9ae118a49fad9c07a60d9af7fa2f";
      powerpc64le-unknown-linux-gnu = "3622e07b266351bb7116146d5939473d2cddb04dbc25c25a63798cf841df9139";
      powerpc64le-unknown-linux-musl = "945c8585c405d2d0d1b4c75bdb8724a3fd8db00dfe1a6edfd7965d4d81f68171";
      riscv64gc-unknown-linux-gnu = "2cd24bfa2d1c5b7f608576131c343bcffa7abce1831d8ce426076501f3df62f1";
      s390x-unknown-linux-gnu = "0c2ac944ff8522eb14dd80cd63432d59d38b8227b8879315dd35d9882b685549";
      loongarch64-unknown-linux-gnu = "65905768192e74d8713e3e600a6899e904a4e76b5a5065f8239480e32672fb46";
      loongarch64-unknown-linux-musl = "7c8e0099347440275fe5ef290212be8815cfaaf706379bbd1aba0ca4e1323215";
      x86_64-unknown-freebsd = "64b4de8f44117ec23a15bb1760d4e50d6cb26dbe4d99d61d3315a268e8da8718";
    };

    selectRustPackage = pkgs: pkgs.rust_1_100;

    rustcPatches = [
      # remove when upgrading to 1.101.0
      # https://github.com/rust-lang/rust/pull/163289
      (fetchpatch {
        name = "rustc-pass-chosen-stack-size-to-llvm-worker-threads.patch";
        url = "https://github.com/rust-lang/rust/commit/0f125fae31e2edec291b23707f0ee9eed9753202.patch";
        hash = "sha256-VlYIo3MolTg7AkBSqT3GkuiCufwFcVrekRuit91yXyE=";
      })

      # remove when upgrading to 1.101.0
      # https://github.com/rust-lang/rust/pull/163483
      # cargo 1.100 has several stricter lints, which upstream only fixed when
      # upgrading their bootstrap compiler to 1.100 during the 1.101 cycle.
      # thus, building rust 1.100 with rust 1.100 fails since warnings are
      # fatal by default.
      (fetchpatch {
        name = "rust-adjust-for-cargo-1.100-lints.patch";
        url = "https://github.com/rust-lang/rust/commit/daa24324904fa6aa460a22de733068c8dcb0323d.patch";
        hash = "sha256-q+5vLk7AB3w0acznCtEOCEnNiMDn/uGmARmpm4UrOn8=";
      })
    ];
  }

  (
    removeAttrs args [
      "llvmPackages_23"
      "llvm"
      "wrapCCWith"
      "overrideCC"
      "pkgsHostTarget"
      "fetchpatch"
      "cargo-auditable"
    ]
  )
