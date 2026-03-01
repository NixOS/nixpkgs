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
    rustcVersion = "1.93.0";
    rustcSha256 = "sha256-aREr2DwyGUP/w5C32y9Z7z/ruV2scA9nwhVvv2tQpwU=";
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
    bootstrapVersion = "1.93.0";

    # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
    bootstrapHashes = {
      i686-unknown-linux-gnu = "10036f92f7dbbef6519bd16c4b9ce3699071e8fa49c58b4b8204b69803c7cd54";
      x86_64-unknown-linux-gnu = "ca55df589f7cd68eec883086c5ff63ece04a1820e6d23e514fbb412cc8bf77a4";
      x86_64-unknown-linux-musl = "3cca6e0536fbb1f9ab17bf5f1ccc62aadbaa936f72326a8972698af10d40799b";
      arm-unknown-linux-gnueabihf = "8788045554de26e5858e64947989dd28ead702e6f3a0cba2855d65730183db18";
      armv7-unknown-linux-gnueabihf = "29a6871136f23545ea2d3f6c0258898440ca8fdca47be0ae7e2e3fcc8a482847";
      aarch64-unknown-linux-gnu = "091f981b95cbc6713ce6d6c23817286d4c10fd35fc76a990a3af430421751cfc";
      aarch64-unknown-linux-musl = "d8beb93a11bc84f131d66b3bcc964acf514371203b8ccb9121e942b9922f210f";
      x86_64-apple-darwin = "0297504189bdee029bacb61245cb131e3a2cc4bfd50c9e11281ea8957706e675";
      aarch64-apple-darwin = "e33cf237cfff8af75581fedece9f3c348e976bb8246078786f1888c3b251d380";
      powerpc64-unknown-linux-gnu = "d535af6a90d79b67a6e08b5fc4442285c3e330541516f4fec72d70f996b7f5b4";
      powerpc64le-unknown-linux-gnu = "dba9e9428e216cc781be25083f3f40eaca432c32fe399bfe4330c234f441a172";
      powerpc64le-unknown-linux-musl = "66213e58a4088eb7291ddebe4d44fffcc50d561e53b00e69a16773ec41de76d3";
      riscv64gc-unknown-linux-gnu = "c4214fa5b68eb15c37e1fd5bd205e5033e40e5a9a146f520c76dadd4cc316e3a";
      s390x-unknown-linux-gnu = "3afdc7d3e24895f3c852ceb7cb3fd080334015d1f5e9dc89e4cd4dc574819c2e";
      loongarch64-unknown-linux-gnu = "0e913233ced8c42fa162d36eabf5629a9ec6e918ef02ddedb79217d93b464a96";
      loongarch64-unknown-linux-musl = "65edcb0b6b4da21df2fb5a4d56c56806a0460bb91e702222006ca9eb1a06f498";
      x86_64-unknown-freebsd = "22660fb38447806d59f39c1a0105e2a9aadf0b2cc442349da9e7574edc1cc84f";
    };

    selectRustPackage = pkgs: pkgs.rust_1_93;
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
