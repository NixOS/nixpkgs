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
  llvmPackages_23,
  llvm,
  cargo-auditable,
  wrapCCWith,
  overrideCC,
  fetchpatch,
}@args:
let
  llvmSharedFor =
    pkgSet:
    pkgSet.llvmPackages_23.libllvm.override (
      {
        enableSharedLibraries = true;
      }
      // lib.optionalAttrs (stdenv.targetPlatform.useLLVM or false) {
        # Force LLVM to compile using clang + LLVM libs when targeting pkgsLLVM
        stdenv = pkgSet.stdenv.override {
          allowedRequisites = null;
          cc = pkgSet.pkgsBuildHost.llvmPackages_23.clangUseLLVM;
        };
      }
    );
in
import ./default.nix
  {
    rustcVersion = "1.100.0";
    rustcSha256 = "sha256-6JBFSFYxFwQ8JKZ8SWcRm3ye0wSCGYgoPnaBEizuyYs=";

    llvmSharedForBuild = llvmSharedFor pkgsBuildBuild;
    llvmSharedForHost = llvmSharedFor pkgsBuildHost;
    llvmSharedForTarget = llvmSharedFor pkgsBuildTarget;
    llvmPackages = llvmPackages_23;

    inherit cargo-auditable;

    # For use at runtime
    llvmShared = llvmSharedFor pkgsHostTarget;

    # Note: the version MUST be the same version that we are building. Upstream
    # ensures that each released compiler can compile itself:
    # https://github.com/NixOS/nixpkgs/pull/351028#issuecomment-2438244363
    bootstrapVersion = "1.100.0";

    # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
    bootstrapHashes = {
      i686-unknown-linux-gnu = "87450cc8bcf2ff0943c8b4193439900b117793f1c59a5a341e576845bb7ecb2d";
      x86_64-unknown-linux-gnu = "5fb0a7fff979867975f375e23687d265254ffc4129325351bb611c209519cd0b";
      x86_64-unknown-linux-musl = "4c047fb70e394d0bac1fc7c009dc55261e5add6bf5928434ee64cd096f7a951e";
      arm-unknown-linux-gnueabihf = "f26f1c2b048657c1713541cd36c61e91e6a64223985acc3aee52e06ac8333827";
      armv7-unknown-linux-gnueabihf = "c010d536ee8302593a82e52dc53153e62bf9b7eae0025e4f9bd0b57754d4608d";
      aarch64-unknown-linux-gnu = "95dabd6b3a6c7114646e067a36f512cbbf03eb09bec8b0dbef454aa2c721c364";
      aarch64-unknown-linux-musl = "62d8efe59297d0620a585035630525e985015b0d14eb8ec71f567abd2d0b0da8";
      x86_64-apple-darwin = "9ff5711ddd7df2e535094406c12e4244cb2aa90c65ddc260467d1d3c51b36e80";
      aarch64-apple-darwin = "bff12b7c3f257e2b0ed6f3f22b6345ef8462762680b26b5ae0cd8e1ed4c1c135";
      powerpc64-unknown-linux-gnu = "13016ff6b67a08147487ad5242d44c02ee5d26c174c812a88f738ab542d99da1";
      powerpc64le-unknown-linux-gnu = "f85f8c81b96dc6f7233ceb20dea9bf4524d4d1bb5581bafd629bb8c5a8cfa394";
      powerpc64le-unknown-linux-musl = "b7b4b1c7527b032c2d47a68103400e8e9614d1c5c3c60dbdc6fd0c3e923f136f";
      riscv64gc-unknown-linux-gnu = "a5028462bb94c90840eb99de7181a28975cbd91e17eed0b59ef653d1285bf829";
      s390x-unknown-linux-gnu = "6239074f93eb762b3ea9030d79798a6ae0a7d8b35ed4033d4b78db5808c8b12d";
      loongarch64-unknown-linux-gnu = "24d446eb4e5706770cfaa64786007325136c872d27b858c16a942ddd1e096bc5";
      loongarch64-unknown-linux-musl = "244c805612e5277e65d66141ff664188bef3a5d552836eb984ce91ed7123ded3";
      x86_64-unknown-freebsd = "496d5cbace80e2f9f72568950aa908045d4d9fd9349c570ac2e5352f891012d9";
    };

    selectRustPackage = pkgs: pkgs.rust_1_100;

    rustcPatches = [
      # remove when upgrading to 1.101.0
      # https://github.com/rust-lang/rust/pull/163289
      (fetchpatch {
        name = "rustc-pass-chosen-stack-size-to-llvm-worker-threads.patch";
        url = "https://github.com/rust-lang/rust/commit/0f125fae31e2edec291b23707f0ee9eed9753202.patch";
        hash = "sha256-VlYIo3MolTg7AkBSqT3GkuiCufwFcVrekRuit91yXyE=";
      })

      # remove when upgrading to 1.101.0
      # https://github.com/rust-lang/rust/pull/163483
      # cargo 1.100 has several stricter lints, which upstream only fixed when
      # upgrading their bootstrap compiler to 1.100 during the 1.101 cycle.
      # thus, building rust 1.100 with rust 1.100 fails since warnings are
      # fatal by default.
      (fetchpatch {
        name = "rust-adjust-for-cargo-1.100-lints.patch";
        url = "https://github.com/rust-lang/rust/commit/daa24324904fa6aa460a22de733068c8dcb0323d.patch";
        hash = "sha256-q+5vLk7AB3w0acznCtEOCEnNiMDn/uGmARmpm4UrOn8=";
      })
    ];
  }

  (
    removeAttrs args [
      "llvmPackages_23"
      "llvm"
      "wrapCCWith"
      "overrideCC"
      "pkgsHostTarget"
      "fetchpatch"
      "cargo-auditable"
    ]
  )
