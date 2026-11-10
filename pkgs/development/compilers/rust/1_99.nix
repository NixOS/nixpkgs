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
    rustcVersion = "1.99.1";
    rustcSha256 = "sha256-21a7xk20kc7aa3iigRptEhxjkziQb9lE9yAonL0CJFw=";

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
    bootstrapVersion = "1.99.1";

    # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
    bootstrapHashes = {
      i686-unknown-linux-gnu = "4ec7d2dece30bbf56c2423c24b87c50dd556fd08e3c803c6c300bcb3343bc42c";
      x86_64-unknown-linux-gnu = "aded4e6c1d580415e7b594a3080d8e23e9cbe06f159f97e300aa6875211f71bf";
      x86_64-unknown-linux-musl = "553f0b4f8789da1552514e99a23d5733e2afb62059c56b8965c8e4b03e6f70a3";
      arm-unknown-linux-gnueabihf = "3ae3d8424847bfa7376b83a576f223e55028cb16f9c8e8b3e20b00450b5c6f9e";
      armv7-unknown-linux-gnueabihf = "60e6c555137de78d29ddfc1cc8a879f418da462ab28ce97701b93a581b1a5ab0";
      aarch64-unknown-linux-gnu = "703b190f0d723ae68985797f3bb5f62f01b1723f138464c6f30f32b766eb0abf";
      aarch64-unknown-linux-musl = "83dc2ff5a720b3d7665dde0524b9d8d5cabb893b8c52ca3485d28702741ec384";
      x86_64-apple-darwin = "ca9900354aeaa5d31c47ce8e07ac90e9fb7377b39ca10e3981a85d6008679522";
      aarch64-apple-darwin = "b73b6a78c4e7171a8fe1b4bee5342273605c5c9a9a4997554c15bb3ce2753b6a";
      powerpc64-unknown-linux-gnu = "3b37ee1866ff6657139d77c0046c2071299e698487da29ab11ded59989b81c67";
      powerpc64le-unknown-linux-gnu = "efed6b2c054100a8fe3d333e4f09941fb2d72daf2d4d6a73baa11be9e355f032";
      powerpc64le-unknown-linux-musl = "3ff2a27b4b7ee1ae0e75450f4e446cd4b27685b2e229a82bee633f3df28dd41c";
      riscv64gc-unknown-linux-gnu = "b66f5a0ce75cab10fa38b6f1ec989d0b2f4310da5efd24f3dd2573e6fae2dfd3";
      s390x-unknown-linux-gnu = "6998cd09229d60468ee2002d3c3bb0db4084e1a6582ef551b3322b520bc3127d";
      loongarch64-unknown-linux-gnu = "cb387b33f097fe9e2c64dd1d3a18200dc36910124eb2aa121b8e406344fb972d";
      loongarch64-unknown-linux-musl = "72ff7e74b93cb78ecb4109dbded6cc50d1a22d8a2c89d6b7ca74e33878b2a5f9";
      x86_64-unknown-freebsd = "ae86ea93813f33003fc329b404bcd9343502621a7a6a0a6f758bfcd16a1f5d87";
    };

    selectRustPackage = pkgs: pkgs.rust_1_99;
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
