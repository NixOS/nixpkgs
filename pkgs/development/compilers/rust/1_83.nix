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
    rustcVersion = "1.83.0";
    rustcSha256 = "ci13O9Tqstgo1901tZ8LAX3fmpfuK0bBt/f6xciEHG4=";

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
    bootstrapVersion = "1.83.0";

    # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
    bootstrapHashes = {
      i686-unknown-linux-gnu = "cb4763e8e04a302486e06195917921f917b485d1138823b9ebae1e23abf55a99";
      x86_64-unknown-linux-gnu = "bd9d53d09d4b60826288336de19fb9c5c7592081e4e4520d6de2f65ee8d79087";
      x86_64-unknown-linux-musl = "d1d379e8bb545466f53f8a5821dfbc7129e8cab046c44c0a9ea089eeff1616e1";
      arm-unknown-linux-gnueabihf = "1ac6ebcb610226c7d81d52ef5158571567d5385a62a41ba73775e52c25666220";
      armv7-unknown-linux-gnueabihf = "747c685a4858f2814a7e493e5d2552ff4234ad41e724560c75738340947cf425";
      aarch64-unknown-linux-gnu = "ec70c500e2744f0db55bd495ef90534a31fd9c0d5f5a2d752182a59e439ddee3";
      aarch64-unknown-linux-musl = "b7aabedc3d6109e2b46e02e2925aafd8d0aa2d319390a257c170b6750ba683ce";
      x86_64-apple-darwin = "d878d4508e0bf2d699e4c8b9b8b9ccd30787859f60149c0934371c53a0fdf013";
      aarch64-apple-darwin = "a605f4e3732eb472dac524861ca8c7456a923e4b4c883b0c8ebfba7550238f41";
      powerpc64le-unknown-linux-gnu = "0bf705a288994d47975e10bd2a709d00e4caf6cc53b02a8847ad607cbc77e24a";
      riscv64gc-unknown-linux-gnu = "f4cb563530ad12daba059373a354cf0dcb53a88e5a5d24928778d2736a0e8c65";
      s390x-unknown-linux-gnu = "502010d6f40b1385c4b99cf74ff0436102efd155ec1e49bca4c02e8c68a4b142";
      x86_64-unknown-freebsd = "3b55ed8afe27032128622b14e4f4b59d66b3cc7ff64e6df7a06d5e224b3de2a1";
    };

    selectRustPackage = pkgs: pkgs.rust_1_83;
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
