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
    rustcVersion = "1.88.0";
    rustcSha256 = "sha256-OpdURDSEiuPRk9HWvIPW8ky4XCYa2V+VX95H7GTPz74=";

    llvmSharedForBuild = llvmSharedFor pkgsBuildBuild;
    llvmSharedForHost = llvmSharedFor pkgsBuildHost;
    llvmSharedForTarget = llvmSharedFor pkgsBuildTarget;

    # For use at runtime
    llvmShared = llvmSharedFor pkgsHostTarget;

    # Expose llvmPackages used for rustc from rustc via passthru for LTO in Firefox
    llvmPackages =
      if (stdenv.targetPlatform.useLLVM or false) then
        callPackage (
          {
            pkgs,
            bootBintoolsNoLibc ? if stdenv.targetPlatform.linker == "lld" then null else pkgs.bintoolsNoLibc,
            bootBintools ? if stdenv.targetPlatform.linker == "lld" then null else pkgs.bintools,
          }:
          let
            llvmPackages = llvmPackages_20;

            setStdenv =
              pkg:
              pkg.override {
                stdenv = stdenv.override {
                  allowedRequisites = null;
                  cc = pkgsBuildHost.llvmPackages_20.clangUseLLVM;
                };
              };
          in
          rec {
            inherit (llvmPackages) bintools;

            libunwind = setStdenv llvmPackages.libunwind;
            llvm = setStdenv llvmPackages.llvm;

            libcxx = llvmPackages.libcxx.override {
              stdenv = stdenv.override {
                allowedRequisites = null;
                cc = pkgsBuildHost.llvmPackages_20.clangNoLibcxx;
                hostPlatform = stdenv.hostPlatform // {
                  useLLVM = !stdenv.hostPlatform.isDarwin;
                };
              };
              inherit libunwind;
            };

            clangUseLLVM = llvmPackages.clangUseLLVM.override { inherit libcxx; };

            stdenv = overrideCC args.stdenv clangUseLLVM;
          }
        ) { }
      else
        llvmPackages_20;

    # Note: the version MUST be the same version that we are building. Upstream
    # ensures that each released compiler can compile itself:
    # https://github.com/NixOS/nixpkgs/pull/351028#issuecomment-2438244363
    bootstrapVersion = "1.88.0";

    # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
    bootstrapHashes = {
      i686-unknown-linux-gnu = "987738444da172dc2d8c9ab93c6178f0000ced44a3089013839e5916755c4844";
      x86_64-unknown-linux-gnu = "ad6f0cc845e7fcca17fd451bafd2c04a7bbcb543f8f3ef5bc412fd1fef99ef7b";
      x86_64-unknown-linux-musl = "8bea28e71582d1bb29031ea2783a6cf2be626fdbcec24b5bca75c85b9b3ca92d";
      arm-unknown-linux-gnueabihf = "cd269f3d53c286c0d0b0014947a4023d86698eac96b456ce746260ef21eec6af";
      armv7-unknown-linux-gnueabihf = "718b8110c8f8ea40282b4a0e2efa09c4a91472eec45739f3b37ecc03f2b53954";
      aarch64-unknown-linux-gnu = "dbc75abc31d142eacf15e60d0e51c4f291539974221d217b80786756b0ce1d6b";
      aarch64-unknown-linux-musl = "9ccb8f16656d2d4e412553ebaf13489198b915519873752dcebb886de50063c6";
      x86_64-apple-darwin = "b36b0bfac17e0a1f6cc06b9fdc4e2131ad578b4122a67792236b58650ae4c5c8";
      aarch64-apple-darwin = "dee921b9a41b1c3fbb088ad31dcca3b232de2cb89c268db75f40912eeaa474db";
      powerpc64-unknown-linux-gnu = "b56e903c6e4d661b6025d45b2675c31d513db207dbd85929c1a25473129275e3";
      powerpc64le-unknown-linux-gnu = "e1f16b2885237695f3cce7fc2f0128a938fc07462b076cb61bd2f06e5f8baf38";
      riscv64gc-unknown-linux-gnu = "6a72741671555fad7ffaceeaa32510c877438087ae71901ccf4a2b03a76c8439";
      s390x-unknown-linux-gnu = "498ec8be66b2c6d8bc77dd06e226d3cc7448bc508ebb9f6d7650db79350d0cb7";
      loongarch64-unknown-linux-gnu = "d4cb16ce9e2f04a7c44efe0abe5fc6cf2b9084f349fac042070882300719cbde";
      loongarch64-unknown-linux-musl = "b9c0c6ca12312dbf8ab80571816fc68b615628ae4fdd0f204c11b71264550b87";
      x86_64-unknown-freebsd = "961de5d723b034c1308d2b4a4d710fe006fb87bdbf914d045c01a5df87a0b332";
    };

    selectRustPackage = pkgs: pkgs.rust_1_88;
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
