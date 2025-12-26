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
    rustcVersion = "1.91.1";
    rustcSha256 = "sha256-ONziBdOfYVcSYfBEQjehzp7+y5cOdg2OxNlXr1tEVyM=";

    llvmSharedForBuild = llvmSharedFor pkgsBuildBuild;
    llvmSharedForHost = llvmSharedFor pkgsBuildHost;
    llvmSharedForTarget = llvmSharedFor pkgsBuildTarget;

    inherit llvmPackages;

    # For use at runtime
    llvmShared = llvmSharedFor pkgsHostTarget;

    # Note: the version MUST be the same version that we are building. Upstream
    # ensures that each released compiler can compile itself:
    # https://github.com/NixOS/nixpkgs/pull/351028#issuecomment-2438244363
    bootstrapVersion = "1.91.1";

    # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
    bootstrapHashes = {
      i686-unknown-linux-gnu = "b596ac56c67cf893e58ecf3263e59ac10157e9f50047e8d3d84faf288273ea47";
      x86_64-unknown-linux-gnu = "1c955c040dd087e4751d15588ddec288b4208bea16f8ec5046c164877e55fff7";
      x86_64-unknown-linux-musl = "e690ea46a73b11268c0487a4bca440142d69de7c0ca062fcdf2b99ad0e42e8e5";
      arm-unknown-linux-gnueabihf = "4899619845a875b2e51825943fad66cf42dced0e1f66470222ff0653776bd59e";
      armv7-unknown-linux-gnueabihf = "c51a61f304c0019c57169b964ec26f7a7ff7dcefaf42b973237f96fb457b25c8";
      aarch64-unknown-linux-gnu = "50213385f288b8760b2efd54ac066ef9a76475e778cbe3b0fcbd3f898fc00674";
      aarch64-unknown-linux-musl = "d374258cd00b4069e44266ab58b321208187511606236ebcc791a5a2d86554e1";
      x86_64-apple-darwin = "05adbd08e6535ed22a9c3d8f11d90df51eb6393488cbbb0c81f2b18d56e4d1ee";
      aarch64-apple-darwin = "f6727c9ab64a5b2a15623f29a023faf0c6a6aeb1347d102b88d595e5c1d9beae";
      powerpc64-unknown-linux-gnu = "94d86d13af288c4a06c8ea8b563e3889d55cc6064a06defd3b612eeeda902b93";
      powerpc64le-unknown-linux-gnu = "355f8043cd506fa718892eeedeebc9d6cc3de1a7757fdb8385c7bdc4cbc853ac";
      powerpc64le-unknown-linux-musl = "c17d51f54c00a371fbab80519b454a901a4b36b9f5a3a692e8816480d8f87067";
      riscv64gc-unknown-linux-gnu = "08230d9c59105270b2e06c5e87078a2a478efcacef8a88aedcccca9f317fa492";
      s390x-unknown-linux-gnu = "fb87330d72636d30f0a9b4b640f994186fc3ad0c0f3c89b2e0f7f31cfd7885f6";
      loongarch64-unknown-linux-gnu = "be6f676ae2ad80d4242798429915f708e3ecae7c895936c5fee172a4f7f2eec8";
      loongarch64-unknown-linux-musl = "7b071bc98d1e42dd802cc5b5bb83a9467d02ad6621231363519c869d322dcd5f";
      x86_64-unknown-freebsd = "9e231fa573b6bb99654a689687aede2014d4c21ac3c8422534c990c859632f50";
    };

    selectRustPackage = pkgs: pkgs.rust_1_91;
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
