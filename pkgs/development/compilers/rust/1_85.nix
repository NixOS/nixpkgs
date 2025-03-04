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
  llvmPackages_19,
  llvm_19,
  wrapCCWith,
  overrideCC,
  fetchpatch,
}@args:
let
  llvmSharedFor =
    pkgSet:
    pkgSet.llvmPackages_19.libllvm.override (
      {
        enableSharedLibraries = true;
      }
      // lib.optionalAttrs (stdenv.targetPlatform.useLLVM or false) {
        # Force LLVM to compile using clang + LLVM libs when targeting pkgsLLVM
        stdenv = pkgSet.stdenv.override {
          allowedRequisites = null;
          cc = pkgSet.pkgsBuildHost.llvmPackages_19.clangUseLLVM;
        };
      }
    );
in
import ./default.nix
  {
    rustcVersion = "1.85.0";
    rustcSha256 = "L08xQv+3yEAhOc+geW4kuqrIuf0/lrLe7DuUtARcaoo=";

    rustcPatches = [
      # Fix for including no_std targets by default, shipping in Rust 1.87
      # https://github.com/rust-lang/rust/pull/137073
      (fetchpatch {
        name = "bootstrap-skip-nostd-docs";
        url = "https://github.com/rust-lang/rust/commit/97962d7643300b91c102496ba3ab6d9279d2c536.patch";
        hash = "sha256-DKl9PWqJP3mX4B1pFeRLQ8/sO6mx1JhbmVLTOOMLZI4=";
      })
    ];

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
            llvmPackages = llvmPackages_19;

            setStdenv =
              pkg:
              pkg.override {
                stdenv = stdenv.override {
                  allowedRequisites = null;
                  cc = pkgsBuildHost.llvmPackages_19.clangUseLLVM;
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
                cc = pkgsBuildHost.llvmPackages_19.clangNoLibcxx;
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
        llvmPackages_19;

    # Note: the version MUST be the same version that we are building. Upstream
    # ensures that each released compiler can compile itself:
    # https://github.com/NixOS/nixpkgs/pull/351028#issuecomment-2438244363
    bootstrapVersion = "1.85.0";

    # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
    bootstrapHashes = {
      i686-unknown-linux-gnu = "bbfdbd15ee6a8414baad487c98d448805d2fa7074107e4eded770926ff5f2545";
      x86_64-unknown-linux-gnu = "be4ba7b777100c851ab268e95f70f405d28d7813ba60a9bdcf4e88c88acf8602";
      x86_64-unknown-linux-musl = "aec38e0eb03cde68f255959cfb389cccf321c7a020d103ea9174d01ab5acba65";
      arm-unknown-linux-gnueabihf = "8a716247a8fe15a6c820d64d25d19c7d0b899a2dadd812bc080e92ebff4fdea5";
      armv7-unknown-linux-gnueabihf = "91d0c9693b218fac740449fa9c3f37e71a680e4be5d27135ac1385f40eb148e0";
      aarch64-unknown-linux-gnu = "0306c30bee00469fbec4b07bb04ea0308c096454354c3dc96a92b729f1c2acd1";
      aarch64-unknown-linux-musl = "390de2f3aff938d04275302d6cb47c92f425b141c9cb68cb6cf237f702298627";
      x86_64-apple-darwin = "69a36d239e38cc08c6366d1d85071847406645346c6f2d2e0dfaf64b58050d3d";
      aarch64-apple-darwin = "3ff45cefaf9a002069902acf3a6332113b76b530bb31803fe5cfd30f7ef8ba03";
      powerpc64le-unknown-linux-gnu = "d0761bf0e1786a46dddfe60cc9397b899f680b86e6aebd7ca16b2a70a9dd631b";
      riscv64gc-unknown-linux-gnu = "5f27e7ed95ccd49fd53e92d6be62042dfdd2861faecad20bf61b0c186ff24df1";
      s390x-unknown-linux-gnu = "7f6ee970e31e448c31c92175684380a73ec7078b15d7a99eac5d445bef1c4b3a";
      x86_64-unknown-freebsd = "6ad090d188079450b1d65e4d539833affac54cfeb504e022b1b56d6d98bb4cbe";
    };

    selectRustPackage = pkgs: pkgs.rust_1_85;
  }

  (
    builtins.removeAttrs args [
      "llvmPackages_19"
      "llvm_19"
      "wrapCCWith"
      "overrideCC"
      "pkgsHostTarget"
      "fetchpatch"
    ]
  )
