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
    rustcVersion = "1.94.1";
    rustcSha256 = "sha256-TBQqYl8S4833FsaK4Z9PYNmK0UgmJ7CFebFYOOla1RQ=";
    rustcPatches = [ ./ignore-missing-docs.patch ];

    llvmSharedForBuild = llvmSharedFor pkgsBuildBuild;
    llvmSharedForHost = llvmSharedFor pkgsBuildHost;
    llvmSharedForTarget = llvmSharedFor pkgsBuildTarget;

    inherit llvmPackages cargo-auditable;

    # For use at runtime
    llvmShared = llvmSharedFor pkgsHostTarget;

    # Note: the version MUST be the same version that we are building. Upstream
    # ensures that each released compiler can compile itself:
    # https://github.com/NixOS/nixpkgs/pull/351028#issuecomment-2438244363
    bootstrapVersion = "1.94.1";

    # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
    bootstrapHashes = {
      i686-unknown-linux-gnu = "b458db6cf8366fa9f830bf05b15e3866fbb2b7e0a1921b91fd52aff9accfb405";
      x86_64-unknown-linux-gnu = "ea7866c5cab0d8c99e7416bcc5f9ecf0e122d396b85c7e7dee5669f10ee80194";
      x86_64-unknown-linux-musl = "5568d1b7992dcb0cabc9936476a0569ff314a3f1322886b4f414eb2d07b0ffd6";
      arm-unknown-linux-gnueabihf = "0b5d43c00ef1a72352f7b08937018ab52f624047f1403e0d2c4d7c67456eff16";
      armv7-unknown-linux-gnueabihf = "31b7deb5f38a504e21865a8bd98ff546884e66910ee11ed55e51a976ac7a645a";
      aarch64-unknown-linux-gnu = "99dba6decb780158b2b94f0054ec15c8cd4a04a497c84349fb86fb7a70722c78";
      aarch64-unknown-linux-musl = "caa1d50676518532cc9b4c4c491f219edbdcb9ebf9e6624432b5b43b87d8cc0a";
      x86_64-apple-darwin = "6d9c5a4bf9962987d616417e2669a50b52cc7ecbfa682d56e9ce8244a57d7b60";
      aarch64-apple-darwin = "630349bd157632ff65aafd1b5753e6a09153278cdac8196e8678b40b30cf1ecb";
      powerpc64-unknown-linux-gnu = "ef5ece383b3b0c2e3b020b95420020b247d73e6885cc9d8b328456b84cfcb6e6";
      powerpc64le-unknown-linux-gnu = "e4375d9081ce229786849ac4cd1be56e3a4ff117371d557ebcdb832c5ec20a4e";
      powerpc64le-unknown-linux-musl = "80fc13d8a78427a7065208a8aac17f542a173efd73c217be11b75de83c2f661f";
      riscv64gc-unknown-linux-gnu = "58038bca429819cc4cd52b9c364983c2e8a4c1dade8beaa0e4edd767e952ebf8";
      s390x-unknown-linux-gnu = "9b1043df30e406bf87cd73be5e5472f0353313ea081bd2ab1feb3b3d45f03e76";
      loongarch64-unknown-linux-gnu = "462881b156c5bd838943c6074649ad296dc87162753010fd328c2b698655b6ec";
      loongarch64-unknown-linux-musl = "5100cd191031a9549b2689b774306e5f37902dcc259a99b9e2de502720c52c0c";
      x86_64-unknown-freebsd = "68b687b408a4b443faeb2c81e2cb1c51f8f738da30ce04b0584db81068d77229";
    };

    selectRustPackage = pkgs: pkgs.rust_1_94;
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
