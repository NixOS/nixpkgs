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
  fetchpatch,
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
    rustcVersion = "1.81.0";
    rustcSha256 = "hyRI/r3/MuUMPJCn4V+bstsTHRPFiP6QcbDtiIN8z6c=";

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
        llvmPackages_18;

    # Note: the version MUST be one version prior to the version we're
    # building
    bootstrapVersion = "1.80.1";

    # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
    bootstrapHashes = {
      i686-unknown-linux-gnu = "1bc0ce998dcf070994ad46292637c5c7368f4bdf1cec1a08baa43af74926be54";
      x86_64-unknown-linux-gnu = "9eedaea9719914a0f4673899aa11693607f25486569913fcca5905ef1da784ec";
      x86_64-unknown-linux-musl = "5b38cc33ed789e15542ee4cbff6fbb11a61d8946b2b1e9e6843386abed398737";
      arm-unknown-linux-gnueabihf = "f07a757846bcc74404380312d7dec4342be887da20e1d5101aaa4cc14d222eb4";
      armv7-unknown-linux-gnueabihf = "1daaf1944f0ba08ae1fcded8698742fdc6ae00027981c5900ea066214137a99d";
      aarch64-unknown-linux-gnu = "4ae791da82be6e7223f4f6cd477799624481aa1011e17c37753a57d257f89198";
      aarch64-unknown-linux-musl = "929d85092b64f69196e8fba2c88ce7a11dd6e4ccd583e4e3363591af041c400f";
      x86_64-apple-darwin = "4fcc0dad8b47066e13877e2839760ef1f40754a90a8fe83ecd4a1f14bf63c71a";
      aarch64-apple-darwin = "170ea11a424d67bbf16df3a4788e0d844ced00490e44c18c366304db1ef8ca6d";
      powerpc64le-unknown-linux-gnu = "0eb2b3efc93cad3baf4653357a4a8a2d5a963ae80dbce8955e1bb4f60e02c659";
      riscv64gc-unknown-linux-gnu = "1c1a70a6a38fb9483d77a330a957ccd436be83d8033a9023fc742ccd8e3ef5ca";
      s390x-unknown-linux-gnu = "ca7f0ede6ec61c9f8bb5ac239c2fd14c1db3b164c58abc934851186489d247df";
      x86_64-unknown-freebsd = "d7f4f66c3cc97616bcd37d9f63ed14c3c22c72a467f308453df2f1b128ffe0bc";
    };

    selectRustPackage = pkgs: pkgs.rust_1_81;

    rustcPatches = [
      (fetchpatch {
        name = "fix-fastCross.patch";
        url = "https://github.com/rust-lang/rust/commit/c15469a7fec811d1a4f69ff26e18c6f383df41d2.patch";
        excludes = [ "src/bootstrap/src/core/build_steps/dist.rs" ];
        hash = "sha256-t8tW0eUZVJu6jUaXo41ZoPblNKisdL6ueoNLaf9Vhog=";
      })
    ];
  }

  (
    builtins.removeAttrs args [
      "llvmPackages_18"
      "llvm_18"
      "wrapCCWith"
      "overrideCC"
      "fetchpatch"
    ]
  )
