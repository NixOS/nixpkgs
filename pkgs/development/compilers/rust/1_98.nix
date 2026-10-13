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
    rustcVersion = "1.98.1";
    rustcSha256 = "sha256-3J+LkXsyRE1sesQ8wbQJAT06mmMzOLtgwUza4dFe5lo=";

    llvmSharedForBuild = llvmSharedFor pkgsBuildBuild;
    llvmSharedForHost = llvmSharedFor pkgsBuildHost;
    llvmSharedForTarget = llvmSharedFor pkgsBuildTarget;

    inherit llvmPackages cargo-auditable;

    # For use at runtime
    llvmShared = llvmSharedFor pkgsHostTarget;

    # Note: the version MUST be the same version that we are building. Upstream
    # ensures that each released compiler can compile itself:
    # https://github.com/NixOS/nixpkgs/pull/351028#issuecomment-2438244363
    bootstrapVersion = "1.98.1";

    # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
    bootstrapHashes = {
      i686-unknown-linux-gnu = "22b82030ccbcb5c77f8740b06cb03a880ca9779e1b1ed9674eabb7b99eae55fc";
      x86_64-unknown-linux-gnu = "24ba1338a2d35c5a3247936546429e163fa674d726102af18bdf624582c57aea";
      x86_64-unknown-linux-musl = "4178195a7f39f2eeec01cc90d579707787a73c0f42d2bf943f78b8dbbac69c04";
      arm-unknown-linux-gnueabihf = "c00bcf4ffe13e48f9fb89e5d643a58af1231baad6d189d1df5ca7b8d2ac71724";
      armv7-unknown-linux-gnueabihf = "50fcf1a6832d0709edec54b022453902ff88cfe4d0532826b42a51913b1462df";
      aarch64-unknown-linux-gnu = "f00ba576645cef658e1deed96fab8f707958e9d58808b16343448b5d1c4f7407";
      aarch64-unknown-linux-musl = "d134f371064241e21ad9dba15887b9ba805410948e05b93284d05a68b943950d";
      x86_64-apple-darwin = "443a1165abbac41c9143b83ff837c0fb1d8c03d2f8fb1da27427bc9fc646aad3";
      aarch64-apple-darwin = "cfc171d8120d401b10a1028c52646dd8e00e3e66852f949061ce087845f55afd";
      powerpc64-unknown-linux-gnu = "a261153ab51f3d1dacde9455f7180110a73c7a956713d19b375a66750928db0b";
      powerpc64le-unknown-linux-gnu = "8fe46e66f8e28d6ba6d40dcb127a0bd0454b7a1fb6a6bf43b97f55cb64e18897";
      powerpc64le-unknown-linux-musl = "fa49cfe9c5fb146901c35ce8652b59f673fa5158a8be3d72dc5cec0ccd4f6928";
      riscv64gc-unknown-linux-gnu = "df44f22fa550f0df5cd32230bd0712e7ce4a9ac9d77f02a33ac105317e0689c4";
      s390x-unknown-linux-gnu = "07a2d8eecad17d2015c7eaa7972ec4e1ada617195bbbb5f6cf8f36b29e5dadd0";
      loongarch64-unknown-linux-gnu = "16c60c1e0612acc52618f9ae7d44486554d63ef9649a3a0516c75e100870dab9";
      loongarch64-unknown-linux-musl = "dd9bfa7281725faf5c95f6be30470f499efcbf81cb0b8b71e7305150291095d0";
      x86_64-unknown-freebsd = "a89cdfd2c7099a5d25c2d398b00fe8cbf641b156b5af75ea572db3f0142b27dd";
    };

    selectRustPackage = pkgs: pkgs.rust_1_98;
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
