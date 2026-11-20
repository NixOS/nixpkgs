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
    rustcVersion = "1.99.0";
    rustcSha256 = "sha256-IDXkB3uDSkL/iv0H8neuPwY0AJi4ax0oQ6ojS0z8rmc=";

    llvmSharedForBuild = llvmSharedFor pkgsBuildBuild;
    llvmSharedForHost = llvmSharedFor pkgsBuildHost;
    llvmSharedForTarget = llvmSharedFor pkgsBuildTarget;

    inherit llvmPackages cargo-auditable;

    # For use at runtime
    llvmShared = llvmSharedFor pkgsHostTarget;

    # Note: the version MUST be the same version that we are building. Upstream
    # ensures that each released compiler can compile itself:
    # https://github.com/NixOS/nixpkgs/pull/351028#issuecomment-2438244363
    bootstrapVersion = "1.99.0";

    # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
    bootstrapHashes = {
      i686-unknown-linux-gnu = "1ce31e45476c18aa3a00d7e349c61e10b1e061ab8f6e42d2eb5b5bbbee17af3d";
      x86_64-unknown-linux-gnu = "de0581ca9d732295a6474cfbd02461db27d69acd5050a8206523a8d6fa1599db";
      x86_64-unknown-linux-musl = "c812c6f52447721fe64cf0feb516769cf758475548a0da25c5b76b65613050a9";
      arm-unknown-linux-gnueabihf = "e686d5e3fd27e86297fde7bc2cf48510a6982a446eb9fee40c736d0c37a4bc94";
      armv7-unknown-linux-gnueabihf = "c3a3c5177971d6818c478b8414c8e942e08c3af6dc0cf607d71d1b613f6aa168";
      aarch64-unknown-linux-gnu = "42214e693ec00733e2a591e67c13af98faf02a82934108a9f37afd247b376dd0";
      aarch64-unknown-linux-musl = "2d979ae621949ef802f357369f888f17c97fd3731a8dc4dc13f713e9d3a6784f";
      x86_64-apple-darwin = "596756101bf43cd335fb247f5cc9ede0c157245523baff25a66694682495cfcb";
      aarch64-apple-darwin = "f35e7c5b2cf63e67c075d323e4d6b87501219311f09744ab24caecb761c96643";
      powerpc64-unknown-linux-gnu = "1c4c53148cd5e78b6a63b869b6b45c104bbba80ae2c165df4dd38549db31ce3d";
      powerpc64le-unknown-linux-gnu = "2db292783506bf29b465fd73f7e4c09445d533ef2a6897c5407463f39048e22e";
      powerpc64le-unknown-linux-musl = "06d2e3bc39cb85b4a1da877e8377d87fb5768fec8180c2cd9bd53b36d1102c5b";
      riscv64gc-unknown-linux-gnu = "c6d21031de5f65d1486ace8f2ab16d8a6962f0a3b58a057d288a0252adbbb2e7";
      s390x-unknown-linux-gnu = "3d576e0ddb69b341593ae0f371e63233b427729fefeb380e9adb46762b23f1f2";
      loongarch64-unknown-linux-gnu = "26969dd72bf9eb4b277d18c7afb3d2ea89ae6b6d4e32796770127d3328e864b6";
      loongarch64-unknown-linux-musl = "6630489e02cfef1f7d8b31d9572a181e0f40a97e6817d851668032507ad5aa4c";
      x86_64-unknown-freebsd = "9a14b060a681932e30c1453c30fe4f95e6170011425d660b97c739521a9f2cb9";
    };

    selectRustPackage = pkgs: pkgs.rust_1_99;
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
