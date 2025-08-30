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
  llvmPackages_20,
  llvm_20,
  wrapCCWith,
  overrideCC,
  fetchpatch,
}@args:
let
  llvmSharedFor =
    pkgSet:
    pkgSet.llvmPackages_20.libllvm.override (
      {
        enableSharedLibraries = true;
      }
      // lib.optionalAttrs (stdenv.targetPlatform.useLLVM or false) {
        # Force LLVM to compile using clang + LLVM libs when targeting pkgsLLVM
        stdenv = pkgSet.stdenv.override {
          allowedRequisites = null;
          cc = pkgSet.pkgsBuildHost.llvmPackages_20.clangUseLLVM;
        };
      }
    );
in
import ./default.nix
  {
    rustcVersion = "1.89.0";
    rustcSha256 = "sha256-JXb59EDdmbAVG9KPWaoKxhAtXE8+1O+KgQyN0FBXJQ0=";

    llvmSharedForBuild = llvmSharedFor pkgsBuildBuild;
    llvmSharedForHost = llvmSharedFor pkgsBuildHost;
    llvmSharedForTarget = llvmSharedFor pkgsBuildTarget;

    # For use at runtime
    llvmShared = llvmSharedFor pkgsHostTarget;

    # Expose llvmPackages used for rustc from rustc via passthru for LTO in Firefox
    llvmPackages = llvmPackages_20;

    # Note: the version MUST be the same version that we are building. Upstream
    # ensures that each released compiler can compile itself:
    # https://github.com/NixOS/nixpkgs/pull/351028#issuecomment-2438244363
    bootstrapVersion = "1.89.0";

    # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
    bootstrapHashes = {
      i686-unknown-linux-gnu = "676ef74ce8ce3137ca66e3941b0221516e1713862053d8aa219e91b491417dd9";
      x86_64-unknown-linux-gnu = "542f517d0624cbee516627221482b166bf0ffe5fd560ec32beb778c01f5c99b6";
      x86_64-unknown-linux-musl = "35695721d53d7eb83ce0153be4c399babf5afd8597bed84f3386d9aac2b4b391";
      arm-unknown-linux-gnueabihf = "e618d08b1547c143cfbfc040023914f4a33a4fcf7addff6778d7cfccbd444c5e";
      armv7-unknown-linux-gnueabihf = "09a295d2d6821a404ca3bf5d1163b9642139105618d0583241b05b7dbf6e22dc";
      aarch64-unknown-linux-gnu = "26d6de84ac59da702aa8c2f903e3c344e3259da02e02ce92ad1c735916b29a4a";
      aarch64-unknown-linux-musl = "b5fdcad8289adf94c45727c33773a05acca994b01b333cf7a508f95fa6adc454";
      x86_64-apple-darwin = "8590528cade978ecb5249184112887489c9d77ae846539e3ef4d04214a6d8663";
      aarch64-apple-darwin = "87baeb57fb29339744ac5f99857f0077b12fa463217fc165dfd8f77412f38118";
      powerpc64-unknown-linux-gnu = "30d97f8d757c6ff171815c8af36eed85e44401a58c5e04f25b721c7776ed8337";
      powerpc64le-unknown-linux-gnu = "80db8e203357a050780fb8a2cdc027b81d5ae1634fa999c3be69cf8a2e10bbf6";
      riscv64gc-unknown-linux-gnu = "3885629641fd670e50c9e6553bdc6505457ef2163757a27dbf33fbc6351b2161";
      s390x-unknown-linux-gnu = "696dad74886467a5092ee8bd2265aaab85039fc563803166966c7cae389e2ef7";
      loongarch64-unknown-linux-gnu = "171696c45e4a91ccf17a239f00d5a3a8bbd40125d7a274506e1630423d714bec";
      loongarch64-unknown-linux-musl = "86e5d8b0f0c868559de3ec2a0902d0e516a710adb845c8904595c54807e821c2";
      x86_64-unknown-freebsd = "4baf0d5a44e64eecc91dc7ab89d8b0a8f8607e1d39b6989767861b34459a0396";
    };

    selectRustPackage = pkgs: pkgs.rust_1_89;
  }

  (
    builtins.removeAttrs args [
      "llvmPackages_20"
      "llvm_20"
      "wrapCCWith"
      "overrideCC"
      "pkgsHostTarget"
      "fetchpatch"
    ]
  )
