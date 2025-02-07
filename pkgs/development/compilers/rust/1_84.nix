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
    rustcVersion = "1.84.0";
    rustcSha256 = "Fc7nOVsH/94CIGBFWzFANm7DoSy76o8e8v83GpzKUb8=";

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
    bootstrapVersion = "1.84.0";

    # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
    bootstrapHashes = {
      i686-unknown-linux-gnu = "3f9fea653bc68139fa1476f9b00ec55a2637650960872029cfc91ea729d0fd82";
      x86_64-unknown-linux-gnu = "de2b041a6e62ec2c37c517eb58518f68fde5fc2f076218393ae06145d92a5682";
      x86_64-unknown-linux-musl = "0e98d242074f566f72bf48dfbd6c8457f6cbc02be7e8e8dac04347ad15ad3f41";
      arm-unknown-linux-gnueabihf = "e571a4e57e60360e0783cd9d4bcc10290394cfd312ede5e4fcc81aebd0625307";
      armv7-unknown-linux-gnueabihf = "b63040017c831aa607d18287d8af6548daca038e9bb95030e0e1f0d45c9c471f";
      aarch64-unknown-linux-gnu = "282d281cb389bdc2c0671c2a74eeda46e010a158810d2137c3a948ae6c713543";
      aarch64-unknown-linux-musl = "1055e2c6f8e3823f5213eb55eb77e63cf6b9bd6eb243897dae7259f4d8ab8c54";
      x86_64-apple-darwin = "eafe087277ad8d7473f978d0779b4504d5b8064a781784aebd3e33c2541a13ce";
      aarch64-apple-darwin = "506dfc14115d2efa96fad9fa542d67027525aa46882a8e1ffb41e891737b689b";
      powerpc64le-unknown-linux-gnu = "26a60519303194e245968b2d34d405a49e20bdb86b240ab230e973e03c283c86";
      riscv64gc-unknown-linux-gnu = "4534d86f55f1851c90097bfc03e38ab88ba6893940a7dcb6dce9139f0aa377fa";
      s390x-unknown-linux-gnu = "76099d34b8e5ae4d47e55e7bd472918cde2c2945b97dca926c739082c051ab2b";
      x86_64-unknown-freebsd = "b484de5908612b3ea132bdd76afde1c980c6bf70cf6f1b27e13d74b3729136b9";
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
