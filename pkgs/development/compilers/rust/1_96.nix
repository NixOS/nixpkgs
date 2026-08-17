# New rust versions should first go to staging.
# Things to check after updating:
# 1. Rustc should produce rust binaries on x86_64-linux, aarch64-linux and x86_64-darwin:
#    i.e. nix-shell -p fd or @GrahamcOfBorg build fd on github
#    This testing can be also done by other volunteers as part of the pull
#    request review, in case platforms cannot be covered.
# 2. The LLVM version used for building should match with rust upstream.
#    Check the version number in the src/llvm-project git submodule in:
#    https://github.com/rust-lang/rust/blob/<version-tag>/.gitmodules

# Note: The way this is structured is:
# 1. Import default.nix, and apply arguments as needed for the file-defined function
# 2. Implicitly, all arguments to this file are applied to the function that is imported.
#    if you want to add an argument to default.nix's top-level function, but not the function
#    it instantiates, add it to the `removeAttrs` call below.
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
  cargo-auditable,
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
    rustcVersion = "1.96.1";
    rustcSha256 = "sha256-0Km1GYxBhoU4rhKvKAZBY1UdBtzOqxHvCxvJqm6Yt6c=";

    llvmSharedForBuild = llvmSharedFor pkgsBuildBuild;
    llvmSharedForHost = llvmSharedFor pkgsBuildHost;
    llvmSharedForTarget = llvmSharedFor pkgsBuildTarget;

    inherit llvmPackages cargo-auditable;

    # For use at runtime
    llvmShared = llvmSharedFor pkgsHostTarget;

    # Note: the version MUST be the same version that we are building. Upstream
    # ensures that each released compiler can compile itself:
    # https://github.com/NixOS/nixpkgs/pull/351028#issuecomment-2438244363
    bootstrapVersion = "1.96.1";

    # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
    bootstrapHashes = {
      i686-unknown-linux-gnu = "9a3ef03fa419d662fbaf9b152a81db96379781771e6853ca06e31215fb177449";
      x86_64-unknown-linux-gnu = "b177534946e6e5422d8a75398b39625c08eabad675c08bd3d6565d3ba90c8450";
      x86_64-unknown-linux-musl = "12404d68457d3344877fbba3fde2c68743cd200fc70475451568e18076cc2a3d";
      arm-unknown-linux-gnueabihf = "c0c4b52bf5614dfcf6b9e94876f97509c71831fc09b8f0f0e228e13ce896ea92";
      armv7-unknown-linux-gnueabihf = "59320d46850c750b0a0d3e49939c00c3eed9917fab9a633300fb4d04bd8cfebc";
      aarch64-unknown-linux-gnu = "212cebf45b0669b2176eb08ffa17c90b07f9de2689d6aae3604d78699fa4f5c2";
      aarch64-unknown-linux-musl = "9e936f24cfd76db8a45ab352919336978531c0fb4eab7a7bdecc76b9562fcbdb";
      x86_64-apple-darwin = "c19cc27b3387e2dfe7eb4b5becc75ab5acf348b2a7f2142ad3716d93a0abaa2a";
      aarch64-apple-darwin = "c080e506af9cba3ca9472c17d989c2d8d5bcfc818eb5e196c77beee982788b50";
      powerpc64-unknown-linux-gnu = "7133e2e1ccf0eb66c4feeca8a2bbf21ad3223904a3459b3f228ff7c8dfc76871";
      powerpc64le-unknown-linux-gnu = "4cde26acb968f98fdb2f7f52e7f78b75a24afdea38abed7217e1cd02c6acbe06";
      powerpc64le-unknown-linux-musl = "d20d271134a11b3ba74c1c54fb926ea09f1c629321dcf53fb5d510f1ac1125a6";
      riscv64gc-unknown-linux-gnu = "b4c54315491239d2a4816535cea22a57ad1021e2529812ccfc938e64c53da276";
      s390x-unknown-linux-gnu = "17cb4a74048429dc03be326f976b35500c96290af248ed212071bafb4e366762";
      loongarch64-unknown-linux-gnu = "7f646ab7f798e7258db25286cbaed4fb54cae90afe44efebc7ff6c6120e4d3d9";
      loongarch64-unknown-linux-musl = "fd8e5e02e5c4bf879a54a31ebc4c24bbd2feb353a54b4e690e1cd04a97c60354";
      x86_64-unknown-freebsd = "8f5f247b7195a8925c092949c4eea96a6228d67e643dc10d97b1ed7c17e4c433";
    };

    selectRustPackage = pkgs: pkgs.rust_1_96;
  }

  (
    removeAttrs args [
      "llvmPackages"
      "llvm"
      "wrapCCWith"
      "overrideCC"
      "pkgsHostTarget"
      "fetchpatch"
      "cargo-auditable"
    ]
  )
