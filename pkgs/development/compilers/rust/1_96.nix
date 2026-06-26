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
    rustcVersion = "1.96.0";
    rustcSha256 = "sha256-6QqesVOylIr6yEDb6dd7ZON2cG8oZDh+53F/dFAEO0Q=";

    llvmSharedForBuild = llvmSharedFor pkgsBuildBuild;
    llvmSharedForHost = llvmSharedFor pkgsBuildHost;
    llvmSharedForTarget = llvmSharedFor pkgsBuildTarget;

    inherit llvmPackages cargo-auditable;

    # For use at runtime
    llvmShared = llvmSharedFor pkgsHostTarget;

    # Note: the version MUST be the same version that we are building. Upstream
    # ensures that each released compiler can compile itself:
    # https://github.com/NixOS/nixpkgs/pull/351028#issuecomment-2438244363
    bootstrapVersion = "1.96.0";

    # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
    bootstrapHashes = {
      i686-unknown-linux-gnu = "1547d452083642c33118cc7fce1697d702ff94fdb4875bf5448fe5b1a6300bbd";
      x86_64-unknown-linux-gnu = "c1130e4f7976f230766ab062b105b1fb050d6a78177db2246a5878fd6a589680";
      x86_64-unknown-linux-musl = "545aff63f37dea2fcbd8037b877219fca6fbba97660bdcb8d3a0fc5df5fa9edf";
      arm-unknown-linux-gnueabihf = "31758cb4175a0b7d2868d149c711ebfbe7b780a9cba5d2f84dce58ddf5a283e4";
      armv7-unknown-linux-gnueabihf = "737d8ab2ace6107e4a3af4189b0e18f805adcafcc00195d5a377fe33e36577ce";
      aarch64-unknown-linux-gnu = "20d5ebe3916fe489891fc577574e47fc679cdf62080c1bb1be6b6905ff4e275b";
      aarch64-unknown-linux-musl = "f55a1f02736d9bcd38969a30f2e6bde8184fd36f13e94f773cac068a56407f16";
      x86_64-apple-darwin = "ddaf6a98ccc500891a74bcb95807a04c89a0d1ad7b9c58bd7116620ff6f903a8";
      aarch64-apple-darwin = "d97daf14c5c346c2d5a3271880d5a06d9885ec9af7e1fd2f072986e338526f8c";
      powerpc64-unknown-linux-gnu = "e49b9fb0671cadef9e5b81871bcfc1dc2c53d7503de7f2d7fa34b7cacc7f62e6";
      powerpc64le-unknown-linux-gnu = "0a80537d96ea86e6520687fa03841f2dfde2c7154ae4bf517d9664d4f13b0c31";
      powerpc64le-unknown-linux-musl = "1deb71349f7ba2af27b9f348429fdae1d7841e6ad6c1bfd5fa9e759922fc79c3";
      riscv64gc-unknown-linux-gnu = "ffdf86a600890771414ada76c711800114501c390631aa7b9c3cbfb94a2f6db3";
      s390x-unknown-linux-gnu = "d29755bb2292ca25ec35ae1407379132a5d87cd916247e895162b93cb91dc5ae";
      loongarch64-unknown-linux-gnu = "3a86d71a43f434234d3ac578ef06a5da86fe5c75ac34e9e43f60fe650577bed2";
      loongarch64-unknown-linux-musl = "6cf0e53ed4678306de34d0f38b934e6dea1b0de56a4f99b725d56be49e1ba8ee";
      x86_64-unknown-freebsd = "5457c15df17ff963b582b95c55fae3bc3736468e4df765182c75c19b1b6e8e74";
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
