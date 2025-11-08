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
    rustcVersion = "1.91.0";
    rustcSha256 = "sha256-Mn9SgVF1MBPworLH9IlVoDPXGPJppLxYYxTWddDUPoo=";

    llvmSharedForBuild = llvmSharedFor pkgsBuildBuild;
    llvmSharedForHost = llvmSharedFor pkgsBuildHost;
    llvmSharedForTarget = llvmSharedFor pkgsBuildTarget;

    inherit llvmPackages;

    # For use at runtime
    llvmShared = llvmSharedFor pkgsHostTarget;

    # Note: the version MUST be the same version that we are building. Upstream
    # ensures that each released compiler can compile itself:
    # https://github.com/NixOS/nixpkgs/pull/351028#issuecomment-2438244363
    bootstrapVersion = "1.91.0";

    # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
    bootstrapHashes = {
      i686-unknown-linux-gnu = "7f455c2b498a6197db7f00d636899ed0fb20ce152f1b1573a3ee524ee98b1b80";
      x86_64-unknown-linux-gnu = "bad9a353330d9f409fe9db790da5701074112f804073506bb2808dd97b940b3c";
      x86_64-unknown-linux-musl = "ac925e53b6cef81445f73e6d45213ab56d11585ac525a3ac21fc09ef4ca664ab";
      arm-unknown-linux-gnueabihf = "4cba316544d91b240529a5e835a42526eaeba85d3574f72b24e7ef73a7bb9132";
      armv7-unknown-linux-gnueabihf = "d86de4cd9e8264ff8dff1b2ec52b8fd2dbb9a01acb6c23ad73e38695d2de98e6";
      aarch64-unknown-linux-gnu = "29c5a608861cc9c06d3f86852a7d7b1a868de2d7ab90d4ff625aeebfb9383390";
      aarch64-unknown-linux-musl = "e97e8821ca7e3aa9986a776cd145ee1b01b8984d31912d345c6059b9535cb72e";
      x86_64-apple-darwin = "b329b458c8074023e5f6934bcd6c0bbef5075ac0090548c3d45a7de82e0c5b0c";
      aarch64-apple-darwin = "ec42d93940933340ee55e67003699ebe264aa82d7cf0d5ae08100c06b1bfacfa";
      powerpc64-unknown-linux-gnu = "9c325b63643bbc4ca98aec820c056f6fb4e82ddc6cc14b1e1382db1f10855ff3";
      powerpc64le-unknown-linux-gnu = "1a357b1e44f7ec7c2da62461a4180d8d8b599dd06045e7e2b83cd7f93972d6d7";
      powerpc64le-unknown-linux-musl = "584b4e37b7c06f850f167b2f8e5095a7a1ca961d8e66c8aae0f4a5ccfba4736e";
      riscv64gc-unknown-linux-gnu = "216a1c6d178e0494ac488f3310e600ef17c62ce38d43e9b14557d1f16f3637f7";
      s390x-unknown-linux-gnu = "e2cda4e86f68e3d4ca9df4f9d80d53fc34a555a96012fceefa4190a388e987d4";
      loongarch64-unknown-linux-gnu = "8121c8d7d9152a835c84bf6b586c107ae582ed051780d37cb1e6f4f9bdad23aa";
      loongarch64-unknown-linux-musl = "58344f7047aceefa44e9aef552b9b84ae3d16fded31a5c6ba9b63abc2c269f43";
      x86_64-unknown-freebsd = "b996571bffafb11951b1a29526bb79518c9f5d74618cf414989b297375c7264f";
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
