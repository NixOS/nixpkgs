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
    rustcVersion = "1.95.0";
    rustcSha256 = "sha256-6puCqD5GlnU3w1ac6db6FoEcBDqW5lE3bDSecCQcpRU=";

    llvmSharedForBuild = llvmSharedFor pkgsBuildBuild;
    llvmSharedForHost = llvmSharedFor pkgsBuildHost;
    llvmSharedForTarget = llvmSharedFor pkgsBuildTarget;

    inherit llvmPackages cargo-auditable;

    # For use at runtime
    llvmShared = llvmSharedFor pkgsHostTarget;

    # Note: the version MUST be the same version that we are building. Upstream
    # ensures that each released compiler can compile itself:
    # https://github.com/NixOS/nixpkgs/pull/351028#issuecomment-2438244363
    bootstrapVersion = "1.95.0";

    # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
    bootstrapHashes = {
      i686-unknown-linux-gnu = "3ef2320bdfa9b69b19c6ca42f950b6bfb9d2af3b925b0c43a6bfecc4d355a66e";
      x86_64-unknown-linux-gnu = "a47ac940abd12399d59ad15c877e7113fa35f2b9ec7e6a8a045d4fd8b9741dea";
      x86_64-unknown-linux-musl = "059086762ac6f4ebe15b5b10e629e4e33e96b372765e65741251f75c4fdfb4e0";
      arm-unknown-linux-gnueabihf = "7d742098e8bb0d10415775634eed83240ae88c1bae6bc73b470ccf0be4629b4c";
      armv7-unknown-linux-gnueabihf = "23a201e72c082c285e957a32b40e1c30805b15d344b84b984be3659e9aefadf6";
      aarch64-unknown-linux-gnu = "3b9385d3144ac57616befa0ccbac524f857ba1b4ab074226e73a24d43568a98e";
      aarch64-unknown-linux-musl = "ad35bcc6928ccb4fd8a12fe19ce88c8fb6e6e3690578a0cb4e0839008017484f";
      x86_64-apple-darwin = "3f3d9f29f8eb7aa821bd8531cb9b1c3c74c3976aa558dfabfcc15c2febb3cfb8";
      aarch64-apple-darwin = "ec23ad2e0e15a7397d2c3c232356149cc871b7df7f47e25c2acb1070157f5398";
      powerpc64-unknown-linux-gnu = "6d89e3739cfb7b3a05880734513361d5860492385217dcd166d033f3e974e823";
      powerpc64le-unknown-linux-gnu = "29e3430f38406c926ee24ff911357dba0c46ff1d3ea59e91625b03677bd51b30";
      powerpc64le-unknown-linux-musl = "b8856b651d64f4f4a2e2ee009366d99ea6135bdf88d15cf2134fc9e166745030";
      riscv64gc-unknown-linux-gnu = "8b527cb1a09f53f83aa3420b4e763c9ea64a54d89e6d7242da35c8aeaa325593";
      s390x-unknown-linux-gnu = "e9598bdd3bc1438d965208ef5186f0dd671826cddd4bcbb20e22a3cec14c111d";
      loongarch64-unknown-linux-gnu = "18038ce7a910930c6742cc76e06fdd4b21b879466a3e67d63a0b6cae955bb4dc";
      loongarch64-unknown-linux-musl = "eef910858c7e833b13c9cb32e79e59d89434999bc2a7d0b6447ab4046eb40461";
      x86_64-unknown-freebsd = "0ffb7aa1999ea12363bbfaea500e152565bb4918ad5a73e9713be40510d75e49";
    };

    selectRustPackage = pkgs: pkgs.rust_1_95;
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
