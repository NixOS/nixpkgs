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
    rustcVersion = "1.87.0";
    rustcSha256 = "sha256-FJu5/Sm+WS2k6HkA/GjwYpo3v2hQtGM53URDTAT9jnY=";

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
    bootstrapVersion = "1.87.0";

    # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
    bootstrapHashes = {
      i686-unknown-linux-gnu = "53138ed9a47d520e4734fb73224925e84c8a90d391db388dcfc03a1b38dac530";
      x86_64-unknown-linux-gnu = "1f6f18ce19387c42968a474cf175e67f99280614ded9c752d5d2e37af3204bcd";
      x86_64-unknown-linux-musl = "ab3951f30b08104de8b578df4776645a81939d7d918000ce231a35389ae59df8";
      arm-unknown-linux-gnueabihf = "9e62054e809534c1b2f62036d8331423a113ab3b8265bca08a715f339dec89c5";
      armv7-unknown-linux-gnueabihf = "9c9133e8a88dede2036d240ed3b792b93a1bbf444b6b2b6998df58b0c7bcdd83";
      aarch64-unknown-linux-gnu = "2c66e31d774a0dcd4422db74584ebc6362ff3ae90c452caff9d2fb912c821e8d";
      aarch64-unknown-linux-musl = "6f301f0ee7d3be2fdd245432c01543a4c61413b5d0a62493e5b0d57d9756b0b6";
      x86_64-apple-darwin = "867a84a93c6ba0b468b78b52004a6307d6f5e2e5598e64f65726c6810b6f7c82";
      aarch64-apple-darwin = "249496972e6f845f052036b9d7e73f816418412de2b266ec717b9050c1810dc3";
      powerpc64-unknown-linux-gnu = "27dd377367d7ba1757e1c768b259622d25a9cd927e126c9788dce9e880ffa925";
      powerpc64le-unknown-linux-gnu = "3f8f68d79460475396a52b5ae70eee73d6fb194fff1c4ff4286b64fbebee4429";
      riscv64gc-unknown-linux-gnu = "ea25b048bad7737188345392d1a0dfa92aa3ed6c00834b0974bdba52cb2398c4";
      s390x-unknown-linux-gnu = "198d3bda0daef12f86b8171025c62fee0a3caa59fa82c22c364d1a69305d8f46";
      loongarch64-unknown-linux-gnu = "61eee03a25a51a74b057d661c3be6c4052e781adcb118b555cb41e0b108cabf4";
      loongarch64-unknown-linux-musl = "b002ed82c1b7ccec039d18c5ee131e953a350c535b710d56ae204935810eb11e";
      x86_64-unknown-freebsd = "b675d11e521e50a45506001479e77a65b9d89cf4caf588381264a511a3c1c49a";
    };

    selectRustPackage = pkgs: pkgs.rust_1_87;
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
