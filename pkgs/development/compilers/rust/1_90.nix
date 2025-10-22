# New rust versions should first go to staging.
# Things to check after updating:
# 1. Rustc should produce rust binaries on x86_64-linux, aarch64-linux and x86_64-darwin:
#    i.e. nix-shell -p fd or @GrahamcOfBorg build fd on github
#    This testing can be also done by other volunteers as part of the pull
#    request review, in case platforms cannot be covered.
# 2. The LLVM version used for building should match with rust upstream.
#    Check the version number in the src/llvm-project git submodule in:
#    https://github.com/rust-lang/rust/blob/<version-tag>/.gitmodules

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
    rustcVersion = "1.90.0";
    rustcSha256 = "sha256-eZqfnLpO1TUeBxBIvPa1VgdV2QCWSN7zOkB91JYfm34=";

    llvmSharedForBuild = llvmSharedFor pkgsBuildBuild;
    llvmSharedForHost = llvmSharedFor pkgsBuildHost;
    llvmSharedForTarget = llvmSharedFor pkgsBuildTarget;

    inherit llvmPackages;

    # For use at runtime
    llvmShared = llvmSharedFor pkgsHostTarget;

    # Note: the version MUST be the same version that we are building. Upstream
    # ensures that each released compiler can compile itself:
    # https://github.com/NixOS/nixpkgs/pull/351028#issuecomment-2438244363
    bootstrapVersion = "1.90.0";

    # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
    bootstrapHashes = {
      i686-unknown-linux-gnu = "8f389b9eb1513785f5589816b60b5a7ca3b24c29bedce7ec0d1c2f8c3ccfb0cc";
      x86_64-unknown-linux-gnu = "e453bae1c68d02fe2eae065c5452d5731308164cd154154c6ee442d2fa590685";
      x86_64-unknown-linux-musl = "251c9fe4e3374f2f9f629a7a83238c618e016b1bda1b9de5e8385cb3a6f057fa";
      arm-unknown-linux-gnueabihf = "61f3987f61bf73562f04dcacfee1a2bad8d16d41f7a3f81ad82dd9b9cbc559ce";
      armv7-unknown-linux-gnueabihf = "06cfb7f1bd3ce50480eed73ad9ae4f8f665d154fa4c713bc08541197eecd4ae0";
      aarch64-unknown-linux-gnu = "293f412e3412c3aa3398c78ebbdf898fa08eacad80c85a7332ce1a455504c5fc";
      aarch64-unknown-linux-musl = "b3ac31ca2e1a720709bf4fb678b2a2f98464c55662c516dfffcbdadd95a420c9";
      x86_64-apple-darwin = "3d1d24e1d4bedb421ca1a16060c21f4d803eaefba585c0b5b5d0b1e56692ef4b";
      aarch64-apple-darwin = "a11b52e34f5e80cb25d49f7943ae60e0b069b431727a4c09b2c890ceebee3687";
      powerpc64-unknown-linux-gnu = "39720c905b8a730cfa725b7e201cd238d15c33112bd4c31b168ca6d1cb898cac";
      powerpc64le-unknown-linux-gnu = "4061405099dc0aba379fe7b7a616d320272ef9325114dfa8f106c303f9b5695c";
      riscv64gc-unknown-linux-gnu = "42cc3b3bb008e24a39bd98887c43ef32c2d997f801c86ca47f2119e5e3589fcb";
      s390x-unknown-linux-gnu = "345c9b902ebee656533d2cfba39c1a020e6a41a4a9609f87430ff8a5d680d649";
      loongarch64-unknown-linux-gnu = "1c116041a2bc7ab2697218f99ad8cccbe3d6b63fcbf516cb9d985cb00efcdb09";
      loongarch64-unknown-linux-musl = "0ae18468c7cd3872d1b685cf960426aeb7467629f69eabb497bee6f0fff9cb04";
      x86_64-unknown-freebsd = "6c7ebf6acbe00873680a190152d47aeebe76e237195b974c593a67227123b2ef";
    };

    selectRustPackage = pkgs: pkgs.rust_1_90;
  }

  (
    removeAttrs args [
      "llvmPackages"
      "llvm"
      "wrapCCWith"
      "overrideCC"
      "pkgsHostTarget"
      "fetchpatch"
    ]
  )
