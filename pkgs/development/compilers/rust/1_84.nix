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
  pkgsHostTarget,
  pkgsTargetTarget,
  makeRustPlatform,
  wrapRustcWith,
  llvmPackages_19,
  llvm_19,
  wrapCCWith,
  overrideCC,
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
    rustcVersion = "1.84.1";
    rustcSha256 = "Xi+11JYopUn3Zxssz5hVqzef1EKDGnwq8W4M3MMbs3U=";

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
    bootstrapVersion = "1.84.1";

    # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
    bootstrapHashes = {
      i686-unknown-linux-gnu = "9a2f107b35ca55439a7de0a74a893ff285766e086f96fb1d7049301b196c5da8";
      x86_64-unknown-linux-gnu = "106c89f23ce1c763fcbea8e2714b2ba869bf7af70804813987a4483896398933";
      x86_64-unknown-linux-musl = "e52236e269ce8f713691d78895365a376002980c011b4bbdd27e4bee0ec1ee9a";
      arm-unknown-linux-gnueabihf = "02273a6326639dedf0c627421851f85b88884d3811de2a7390f189575d23b4b4";
      armv7-unknown-linux-gnueabihf = "434895ed6cf922a3c0fe11a6af7f4e382093cc9edf6c250e49fbfcecd25ada59";
      aarch64-unknown-linux-gnu = "be89f6ad9b70cc4b25182ae299f94ab047a713a51fddf95284823c8afe4aef85";
      aarch64-unknown-linux-musl = "8a80398ed1942e8020599b8f1c53ae9775a6c8bed6af252c48a5fb967accd5f1";
      x86_64-apple-darwin = "c2c80ffef15946abfb08dac6ad54c07f9d95ae56c65fc94c4c10e07b60acb883";
      aarch64-apple-darwin = "49be10fa1a1de14e36d37cc412b7c44e01896c0a86a2d0d35ee26704a59adba7";
      powerpc64le-unknown-linux-gnu = "7c56d9b5e2dfbd6a0a18307d96b703d6d70d1cf7bb337ea8865dfdd5e0a38d84";
      riscv64gc-unknown-linux-gnu = "0e07fe7a0df2220cea37581061ed52576a44dec10866ec8f860f71a98bf41412";
      s390x-unknown-linux-gnu = "9d6ab731c0cb315349cf5cbbeb88149adbd7165dbeec76f7c723d0b9796c4422";
      x86_64-unknown-freebsd = "7aa4089315d3ac9eefd7f885283df99b2c4cb930316f0be3bf867d41217b6d05";
    };

    selectRustPackage = pkgs: pkgs.rust_1_84;
  }

  (
    builtins.removeAttrs args [
      "llvmPackages_19"
      "llvm_19"
      "wrapCCWith"
      "overrideCC"
      "pkgsHostTarget"
    ]
  )
