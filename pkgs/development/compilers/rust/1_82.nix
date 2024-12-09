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
          cc = pkgSet.pkgsBuildHost.llvmPackages_18.clangUseLLVM;
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
            llvmPackages = llvmPackages_18;

            setStdenv =
              pkg:
              pkg.override {
                stdenv = stdenv.override {
                  allowedRequisites = null;
                  cc = pkgsBuildHost.llvmPackages_18.clangUseLLVM;
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
                cc = pkgsBuildHost.llvmPackages_18.clangNoLibcxx;
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

    # Note: the version MUST be the same version that we are building. Upstream
    # ensures that each released compiler can compile itself:
    # https://github.com/NixOS/nixpkgs/pull/351028#issuecomment-2438244363
    bootstrapVersion = "1.82.0";

    # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
    bootstrapHashes = {
      i686-unknown-linux-gnu = "77b261fb3d9efa7fe39e87c024987495e03b647b6cb23a66b8e69aeb12a8be61";
      x86_64-unknown-linux-gnu = "0265c08ae997c4de965048a244605fb1f24a600bbe35047b811c638b8fcf676b";
      x86_64-unknown-linux-musl = "9dd781c64f71c1d3f854b0937eb751f19e8ebac1110e68e08b94223ad9b022ba";
      arm-unknown-linux-gnueabihf = "d6a2857d0ab8880c3bc691607b10b68fb2750eae35144e035a9a5eeef820b740";
      armv7-unknown-linux-gnueabihf = "eff9939c4b98c6ad91a759fa1a2ebdd81b4d05e47ac523218bf9d7093226589b";
      aarch64-unknown-linux-gnu = "d7db04fce65b5f73282941f3f1df5893be9810af17eb7c65b2e614461fe31a48";
      aarch64-unknown-linux-musl = "f061eabf0324805637c1e89e7d936365f705be1359699efbda59b637dbe9715f";
      x86_64-apple-darwin = "b1a289cabc523f259f65116a41374ac159d72fbbf6c373bd5e545c8e835ceb6a";
      aarch64-apple-darwin = "49b6d36b308addcfd21ae56c94957688338ba7b8985bff57fc626c8e1b32f62c";
      powerpc64le-unknown-linux-gnu = "44f3a1e70be33f91927ae8d89a11843a79b8b6124d62a9ddd9030a5275ebc923";
      riscv64gc-unknown-linux-gnu = "a72e8aa3fff374061ff90ada317a8d170c2a15eb079ddc828c97189179d3eebd";
      s390x-unknown-linux-gnu = "63760886a9b2de6cb38f75a236db358939d904e205e1e2bc9d96cec69e00ae83";
      x86_64-unknown-freebsd = "f7b51943dbed0af3387e3269c1767fee916fb22b8e7897b3594bf5e422403137";
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
      "pkgsHostTarget"
    ]
  )
