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
  CoreFoundation,
  Security,
  SystemConfiguration,
  pkgsBuildTarget,
  pkgsBuildBuild,
  pkgsBuildHost,
  pkgsTargetTarget,
  makeRustPlatform,
  wrapRustcWith,
  llvmPackages_18,
  llvm_18,
  wrapCCWith,
  overrideCC,
}@args:
let
  llvmSharedFor =
    pkgSet:
    pkgSet.llvmPackages_18.libllvm.override (
      {
        enableSharedLibraries = true;
      }
      // lib.optionalAttrs (stdenv.targetPlatform.useLLVM or false) {
        # Force LLVM to compile using clang + LLVM libs when targeting pkgsLLVM
        stdenv = pkgSet.stdenv.override {
          allowedRequisites = null;
          cc = pkgSet.llvmPackages_18.clangUseLLVM;
        };
      }
    );
in
import ./default.nix
  {
    rustcVersion = "1.80.1";
    rustcSha256 = "sha256-LAuPZDlC3LgQy8xQ8pJWSxtuRNtdX0UJEVOZbfldLcQ=";

    llvmSharedForBuild = llvmSharedFor pkgsBuildBuild;
    llvmSharedForHost = llvmSharedFor pkgsBuildHost;
    llvmSharedForTarget = llvmSharedFor pkgsBuildTarget;

    # For use at runtime
    llvmShared = llvmSharedFor { inherit llvmPackages_18 stdenv; };

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
            llvmPackages = llvmPackages_18;

            setStdenv =
              pkg:
              pkg.override {
                stdenv = stdenv.override {
                  allowedRequisites = null;
                  cc = llvmPackages.clangUseLLVM;
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
                cc = llvmPackages.clangNoLibcxx;
                hostPlatform = stdenv.hostPlatform // {
                  useLLVM = !stdenv.isDarwin;
                };
              };
              inherit libunwind;
            };

            clangUseLLVM = llvmPackages.clangUseLLVM.override { inherit libcxx; };

            stdenv = overrideCC args.stdenv clangUseLLVM;
          }
        ) { }
      else
        llvmPackages_18;

    # Note: the version MUST be one version prior to the version we're
    # building
    bootstrapVersion = "1.79.0";

    # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
    bootstrapHashes = {
      i686-unknown-linux-gnu = "0a1e371809446cd77dba7abce2afb4efac8d8b2e63483cfe19f1c98bf9ab7855";
      x86_64-unknown-linux-gnu = "628efa8ef0658a7c4199883ee132281f19931448d3cfee4ecfd768898fe74c18";
      x86_64-unknown-linux-musl = "2e4b0e40d027e2b31a40163986b4c04dfd0bce41c706a99f2e82ba473a4383de";
      arm-unknown-linux-gnueabihf = "ce8d8d296277a06e0d2f63a21a0586717e09be3df28c0d1a04bc2c6f85eecc15";
      armv7-unknown-linux-gnueabihf = "31968f88b22058e384dfb3cdf3efe7f60c03481d790300fcffc420d5ba3851f2";
      aarch64-unknown-linux-gnu = "f7d3b31581331b54af97cf3162e65b8c26c8aa14d42f71c1ce9adc1078ef54e5";
      aarch64-unknown-linux-musl = "f8100c806754cd21600ded26546467a1a242db9b9ab8a6a666656e3cc4edfa52";
      x86_64-apple-darwin = "62f018aad30bafa0ef8bff0ed60d5d45e6cadc799769aad9d945509203e9f921";
      aarch64-apple-darwin = "e70a9362975b94df7dbc6e2ed5ceab4254dd32f72ba497ff4a70440ace3f729f";
      powerpc64le-unknown-linux-gnu = "9865eeebb5bb20006367d3148d9116576499ec958d847e22b645f008a1bc4170";
      riscv64gc-unknown-linux-gnu = "c8d38e600ef4dea8b375df2d08153393816ffd3dcab18e4d081ddc19e28b5a40";
      s390x-unknown-linux-gnu = "1e9f1b27ce47d831108e1d1bb6ef7ab86f95bedfea843318292f821142fe1f6c";
      x86_64-unknown-freebsd = "3c8005f488b8dda0fc6d47928868200852106cac2b568934ae9a2e5c89d3a50d";
    };

    selectRustPackage = pkgs: pkgs.rust_1_80;

    rustcPatches = [ ];
  }

  (
    builtins.removeAttrs args [
      "llvmPackages_18"
      "llvm_18"
      "wrapCCWith"
      "overrideCC"
    ]
  )
