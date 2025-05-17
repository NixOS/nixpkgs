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
  llvmPackages,
  llvm,
  wrapCCWith,
  overrideCC,
  fetchpatch,
}@args:
let
  llvmSharedFor =
    pkgSet:
    pkgSet.llvmPackages.libllvm.override (
      {
        enableSharedLibraries = true;
      }
      // lib.optionalAttrs (stdenv.targetPlatform.useLLVM or false) {
        # Force LLVM to compile using clang + LLVM libs when targeting pkgsLLVM
        stdenv = pkgSet.stdenv.override {
          allowedRequisites = null;
          cc = pkgSet.pkgsBuildHost.llvmPackages.clangUseLLVM;
        };
      }
    );
in
import ./default.nix
  {
    rustcVersion = "1.86.0";
    rustcSha256 = "sha256-AionKG32eQCgRNIn2dtp1HMuw9gz5P/CWcRCXtce7YA=";

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
            setStdenv =
              pkg:
              pkg.override {
                stdenv = stdenv.override {
                  allowedRequisites = null;
                  cc = pkgsBuildHost.llvmPackages.clangUseLLVM;
                };
              };
          in
          rec {
            inherit (args.llvmPackages) bintools;

            libunwind = setStdenv args.llvmPackages.libunwind;
            llvm = setStdenv args.llvmPackages.llvm;

            libcxx = args.llvmPackages.libcxx.override {
              stdenv = stdenv.override {
                allowedRequisites = null;
                cc = pkgsBuildHost.llvmPackages.clangNoLibcxx;
                hostPlatform = stdenv.hostPlatform // {
                  useLLVM = !stdenv.hostPlatform.isDarwin;
                };
              };
              inherit libunwind;
            };

            clangUseLLVM = args.llvmPackages.clangUseLLVM.override { inherit libcxx; };

            stdenv = overrideCC args.stdenv clangUseLLVM;
          }
        ) { }
      else
        args.llvmPackages;

    # Note: the version MUST be the same version that we are building. Upstream
    # ensures that each released compiler can compile itself:
    # https://github.com/NixOS/nixpkgs/pull/351028#issuecomment-2438244363
    bootstrapVersion = "1.86.0";

    # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
    bootstrapHashes = {
      i686-unknown-linux-gnu = "6d39b7599f872fe330e64800ca2ebfd58624d78e135c491226f44f5ff68b900d";
      x86_64-unknown-linux-gnu = "f6a8c0d8b8a8a737c40eee78abe286a3cbe984d96b63de9ae83443360e3264bf";
      x86_64-unknown-linux-musl = "2d399a43e1e4a2dea0e16f83cd0a1dd53f7f32250ba25970ea5d9c31a16df611";
      arm-unknown-linux-gnueabihf = "d7af8bdf97c76b2c2df50486597dd0ad8af36b9213549f3e0d15384d36bc0a37";
      armv7-unknown-linux-gnueabihf = "fbddb4d24d701362c65201dc0905f7445eb9dfa3a5d767ff29a5d3f676957253";
      aarch64-unknown-linux-gnu = "460058cd78f06875721427a42a5ce6a8b8ef2c0c3225fccfae149d9345572ff4";
      aarch64-unknown-linux-musl = "fcfc61f571b25c13f89545f0ab2fe1950751d8d50bcdc2d40c136e0df533d5a4";
      x86_64-apple-darwin = "bf8121850b2f6a46566f6c2bbe9fa889b915b1039febf36853ea9d9c4256c67d";
      aarch64-apple-darwin = "01271f83549c3b5191334a566289aa41615ea8f8f530f49548733585f21c7e5a";
      powerpc64le-unknown-linux-gnu = "9b104428e2b0377dbdb9dc094eb4d9f4893ada0b80d2b315f0c4ea2135ed9007";
      riscv64gc-unknown-linux-gnu = "b74cd0bf5ddeb759cd75fb4d7f3f90972dbab6e77569484491ab7ecf073558a8";
      s390x-unknown-linux-gnu = "721121bcb8f96b98942289f627f9054ded92215c391d48f459527d4b0c63114f";
      loongarch64-unknown-linux-gnu = "0e7827b14c77ce3ede5ba414de9806b52c655940f95fddd3e07873b8fe46c8bf";
      loongarch64-unknown-linux-musl = "d769fb639a9116c77d5b35cb0abe4fd3bc85b6d578fe7e4440c218530e32e1cf";
      x86_64-unknown-freebsd = "fc424d582cd45df010f3b3ff76768f6c87942002421f8896daf7e3989a8f72b4";
    };

    selectRustPackage = pkgs: pkgs.rust_1_86;
  }

  (
    builtins.removeAttrs args [
      "llvmPackages"
      "llvm"
      "wrapCCWith"
      "overrideCC"
      "pkgsHostTarget"
      "fetchpatch"
    ]
  )
