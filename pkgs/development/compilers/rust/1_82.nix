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
    rustcVersion = "1.82.0";
    rustcSha256 = "fFP0UJ7aGE4XTvprp9XutYZYVobOjt78eBorEafPUSo=";

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
    bootstrapVersion = "1.81.0";

    # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
    bootstrapHashes = {
      i686-unknown-linux-gnu = "0ab6ff2da7218220a2fb6e9538f5582c5d27448e91ff6ea2e296b2aee2b5e2d9";
      x86_64-unknown-linux-gnu = "4ca7c24e573dae2f382d8d266babfddc307155e1a0a4025f3bc11db58a6cab3e";
      x86_64-unknown-linux-musl = "2a0829c842425ab316a63adb0d604421be1c4df332388ac26d63aef47e857c12";
      arm-unknown-linux-gnueabihf = "0da7b4a3b760fa514ba5e1a731fd212f1d082468f118f19e852136a30d2c0253";
      armv7-unknown-linux-gnueabihf = "5a8d799a09cc605ea3a88dc43bd348bd6335847a0b71ba8e73b40968a0a7bf6f";
      aarch64-unknown-linux-gnu = "ef4da9c1ecd56bbbb36f42793524cce3062e6a823ae22cb679a945c075c7755b";
      aarch64-unknown-linux-musl = "fab9a1a69e61326399becab2571381b079ee42f2b648d862b0c3df05004dc864";
      x86_64-apple-darwin = "f74d8ad24cc3cbfb825da98a08d98319565e4d18ec2c3e9503bf0a33c81ba767";
      aarch64-apple-darwin = "60a41dea4ae0f4006325745a6400e6fdc3e08ad3f924fac06f04c238cf23f4ec";
      powerpc64le-unknown-linux-gnu = "bf98b27de08a2fd5a2202a2b621b02bfde2a6fde397df2a735d018aeffcdc5e2";
      riscv64gc-unknown-linux-gnu = "664e7a50c03848afc86d579a9cbf82cd0b2291a97776f7f81cee9bbf9fc1f648";
      s390x-unknown-linux-gnu = "e0450ff125cadd3813c7888f5ca42f78e68df13c212b12d5eac3325062632723";
      x86_64-unknown-freebsd = "b96ebbc043058eedebccd20f1d01e64f2241107665fe2336e6927966d8b9d8d3";
    };

    selectRustPackage = pkgs: pkgs.rust_1_82;

    rustcPatches = [
      (fetchpatch {
        name = "fix-fastCross.patch";
        url = "https://github.com/rust-lang/rust/commit/c15469a7fec811d1a4f69ff26e18c6f383df41d2.patch";
        hash = "sha256-lFc48AMoGf4LCP65IsXS5rEB9eYacTP8ADftQkj8zkg=";
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
