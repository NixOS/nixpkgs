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
  llvmPackages,
  llvm,
  cargo-auditable,
  wrapCCWith,
  overrideCC,
  fetchpatch,
}@args:
let
  llvmSharedFor =
    pkgSet:
    pkgSet.llvmPackages.libllvm.override (
      {
        enableSharedLibraries = true;
      }
      // lib.optionalAttrs (stdenv.targetPlatform.useLLVM or false) {
        # Force LLVM to compile using clang + LLVM libs when targeting pkgsLLVM
        stdenv = pkgSet.stdenv.override {
          allowedRequisites = null;
          cc = pkgSet.pkgsBuildHost.llvmPackages.clangUseLLVM;
        };
      }
    );
in
import ./default.nix
  {
    rustcVersion = "1.94.0";
    rustcSha256 = "sha256-uD+SHNPzIf9hT5wGqLhw2JKZ/AKIi0ilVJaDo2gjR0w=";
    rustcPatches = [ ./ignore-missing-docs.patch ];

    llvmSharedForBuild = llvmSharedFor pkgsBuildBuild;
    llvmSharedForHost = llvmSharedFor pkgsBuildHost;
    llvmSharedForTarget = llvmSharedFor pkgsBuildTarget;

    inherit llvmPackages cargo-auditable;

    # For use at runtime
    llvmShared = llvmSharedFor pkgsHostTarget;

    # Note: the version MUST be the same version that we are building. Upstream
    # ensures that each released compiler can compile itself:
    # https://github.com/NixOS/nixpkgs/pull/351028#issuecomment-2438244363
    bootstrapVersion = "1.94.0";

    # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
    bootstrapHashes = {
      i686-unknown-linux-gnu = "4c309c178f96770968ce79226af935996b1715389abf4bc08bdd4f596660201d";
      x86_64-unknown-linux-gnu = "3bb1925a0a5ad2c17be731ee6e977e4a68490ab2182086db897bd28be21e965f";
      x86_64-unknown-linux-musl = "57a78e193b11573da839c7177b8d29552aeb2c4751973179a384d472210f9c89";
      arm-unknown-linux-gnueabihf = "2abf1ca017b0762f0750bcebff1c4814805a28c66935c09139d2adf3565105c6";
      armv7-unknown-linux-gnueabihf = "338514f8c7adccb67c851ce220baceef0cec53b26291ae805094dbdbb5ceaad1";
      aarch64-unknown-linux-gnu = "a0dc5a65ab337421347533e5be11d3fab11f119683a0dbd257ef3fe968bd2d72";
      aarch64-unknown-linux-musl = "8ff50ffcf1da9aaea29767864abcdc4cce2eb840d3200e9a3ff585ad17f002b8";
      x86_64-apple-darwin = "97724032da92646194a802a7991f1166c4dc9f0a63f3bb01a53860e98f31d08c";
      aarch64-apple-darwin = "94903e93a4334d42bb6d92377a39903349c07f3709c792864bcdf7959f3c8c7d";
      powerpc64-unknown-linux-gnu = "34dcc95d487f5a7da33ec05abf394515f80559d030e45b1c1744e2005690d720";
      powerpc64le-unknown-linux-gnu = "fc6fa22878c5d12cb60e0ebaffdad70161965719bcc5d0b6793b132a0de8f759";
      powerpc64le-unknown-linux-musl = "52472bac4cdecb95e7a091ad9bb328747a09b8cfe7082a90511d5250a330cdbc";
      riscv64gc-unknown-linux-gnu = "ee71279fee2755d7f613597b24c8b168cc4e404d17e4e966c6b92aaf4d3c21ef";
      s390x-unknown-linux-gnu = "a27d205e95d9e1ec3f14d94c2cc28b1b6d3b64dda50c1f25a787a30989782a18";
      loongarch64-unknown-linux-gnu = "12361da66b693b848f6908d2321d03bb53ee9037bcc3d406876e6fc7b945e23d";
      loongarch64-unknown-linux-musl = "42278996624153a2b872905be08796515e49079dfcdee5f28d4c389f18c2f0e5";
      x86_64-unknown-freebsd = "6fba7bf41553e67b6d0f2014f7e128818b92f215b1e96a100ac5eaed06a41a04";
    };

    selectRustPackage = pkgs: pkgs.rust_1_94;
  }

  (
    removeAttrs args [
      "llvmPackages"
      "llvm"
      "wrapCCWith"
      "overrideCC"
      "pkgsHostTarget"
      "fetchpatch"
      "cargo-auditable"
    ]
  )
