# Full-source Rust bootstrap chain via mrustc.
#
# mrustc (a C++ Rust compiler) builds a minimal rustc 1.90.0; that compiler then
# builds rustc 1.90.0 from source, which bootstraps 1.91.1, and so on up to the
# version used at the current rust path (1.96.0). No prebuilt rustc binary is
# ever downloaded — the resulting compiler's closure contains no binaryNativeCode
# rust toolchain.
#
# Each link reuses ./default.nix (and thus ./rustc.nix) the same way the
# binary-bootstrapped compiler does. That binary bootstrap was the Nixpkgs
# default up to at least 26.05, and stays the path on every platform mrustc
# cannot bootstrap (see all-packages.nix). The differences here are:
#   * its bootstrap compiler is the *previous* link (mrustc for the base link),
#     via default.nix's `bootstrapPackagesOverride`;
#   * intermediate links build with `minimal = true` (host target only, no docs,
#     no rustc-dev); only the final link does the full build.
#
# `mrustcStage0` must be an attrset `{ rustc; cargo; }` exposing rustc 1.90.0 and
# a matching cargo (e.g. `{ rustc = mrustc-bootstrap; cargo = mrustc-bootstrap; }`,
# since that derivation provides both `bin/rustc` and `bin/cargo`).
#
# The whole chain is pinned to LLVM 21 (the version rustc 1.90–1.96 build with),
# independent of the Nixpkgs default `llvmPackages`. It currently coincides with
# that default, but the pin must move with the rustc versions, not with the
# default.
#
# Currently x86_64-linux only, because that is the one target mrustc fully
# bootstraps and CI-tests (its other targets are secondary and not bootstrap-
# tested). This is a limitation of the entry point, not of the design: in
# principle the x86_64-linux source-bootstrapped rustc could cross-compile rustc
# for other hosts, removing the binary bootstrap there too. That work is out of
# scope here, so non-x86_64-linux keeps the binary bootstrap.
{
  lib,
  stdenv,
  newScope,
  callPackage,
  pkgsBuildBuild,
  pkgsBuildHost,
  pkgsBuildTarget,
  pkgsHostTarget,
  pkgsTargetTarget,
  makeRustPlatform,
  wrapRustcWith,
  llvmPackages_21,
  cargo-auditable,
  mrustcStage0,
}@args:

let
  # Pin the whole chain to LLVM 21 regardless of the default `llvmPackages`.
  llvmPackages = llvmPackages_21;

  llvmSharedFor = pkgSet: pkgSet.llvmPackages_21.libllvm.override { enableSharedLibraries = true; };

  # rustc.nix reads `targetPlatforms`/`targetPlatformsWithHostTools`/
  # `badTargetPlatforms` off its bootstrap compiler for the built rustc's own
  # passthru. mrustc-bootstrap is a plain derivation, so graft on the canonical
  # lists — defined once in rust/binary.nix and carried by the prebuilt bootstrap
  # compiler. They then propagate down the whole chain via each link's passthru
  # and the rustc wrapper, while mrustc's own meta.platforms keeps the chain
  # marked x86_64-linux-only.
  baseRustc = mrustcStage0.rustc // {
    inherit (pkgsBuildHost.rust_1_96.packages.prebuilt.rustc-unwrapped)
      targetPlatforms
      targetPlatformsWithHostTools
      badTargetPlatforms
      ;
  };

  # Ordered chain, base first. Each `hash` is of
  # https://static.rust-lang.org/dist/rustc-<version>-src.tar.gz
  # (fetch with `nix-prefetch-url --type sha256 <url>`).
  versions = [
    {
      version = "1.90.0";
      hash = "sha256-eZqfnLpO1TUeBxBIvPa1VgdV2QCWSN7zOkB91JYfm34=";
    }
    {
      version = "1.91.1";
      hash = "sha256-ONziBdOfYVcSYfBEQjehzp7+y5cOdg2OxNlXr1tEVyM=";
    }
    {
      version = "1.92.0";
      hash = "sha256-ng0sp1x+J1/cdYJVv0sDr7PWXRVDYCdGkHyTO2kBw7g=";
    }
    {
      version = "1.93.1";
      hash = "sha256-TCMKRLPZyfPO+VCUNxn4OABY0nyR/aXjapqUfvAT4B8=";
    }
    {
      version = "1.94.1";
      hash = "sha256-TBQqYl8S4833FsaK4Z9PYNmK0UgmJ7CFebFYOOla1RQ=";
    }
    {
      version = "1.95.0";
      hash = "sha256-6puCqD5GlnU3w1ac6db6FoEcBDqW5lE3bDSecCQcpRU=";
    }
    {
      # Same source tarball as the binary-bootstrapped rust/1_96.nix.
      version = "1.96.0";
      hash = "sha256-6QqesVOylIr6yEDb6dd7ZON2cG8oZDh+53F/dFAEO0Q=";
    }
  ];

  # "1.90.0" -> "rust_1_90", "1.94.1" -> "rust_1_94"
  attrName = version: "rust_" + lib.concatStringsSep "_" (lib.take 2 (lib.splitString "." version));

  nLinks = lib.length versions;

  mkLink =
    index: entry:
    let
      inherit (entry) version;
      isFinal = index == nLinks - 1;
      isBase = index == 0;
      prevAttr = attrName (lib.elemAt versions (index - 1)).version;
      # base link bootstraps from mrustc; later links from the previous link.
      override =
        if isBase then
          {
            rustc = baseRustc;
            inherit (mrustcStage0) cargo;
          }
        else
          {
            inherit (chain.${prevAttr}.packages.stable) rustc cargo;
          };
    in
    import ./default.nix
      {
        rustcVersion = version;
        rustcSha256 = entry.hash;

        # Intermediate links only need to compile the next rustc.
        minimal = !isFinal;
        enableRustcDev = isFinal;

        # Keep the whole chain free of the binary-bootstrapped cargo-auditable.
        cargoAuditable = false;

        llvmSharedForBuild = llvmSharedFor pkgsBuildBuild;
        llvmSharedForHost = llvmSharedFor pkgsBuildHost;
        llvmSharedForTarget = llvmSharedFor pkgsBuildTarget;
        llvmShared = llvmSharedFor pkgsHostTarget;
        inherit llvmPackages cargo-auditable;

        bootstrapPackagesOverride = override;

        # Only consulted for `buildRustPackages` (build-time proc-macro/build.rs
        # tooling) and cross; the override above is what actually breaks the
        # bootstrap cycle for native build==host. Point each link at itself,
        # mirroring rust/1_95.nix's `selectRustPackage = pkgs: pkgs.rust_1_95`.
        selectRustPackage = pkgs: pkgs.rustcBootstrapChain.${attrName version};

        # Unused by chain links (the override path wins), but default.nix's
        # lazily-evaluated `packages.prebuilt` still references them.
        bootstrapVersion = version;
        bootstrapHashes = { };
      }
      (
        removeAttrs args [
          "llvmPackages_21"
          "cargo-auditable"
          "pkgsHostTarget"
          "mrustcStage0"
        ]
      );

  chain = lib.listToAttrs (
    lib.imap0 (index: entry: lib.nameValuePair (attrName entry.version) (mkLink index entry)) versions
  );
in
chain
// {
  # The fully source-bootstrapped compiler equivalent to the current rust path.
  final = chain.${attrName (lib.last versions).version};
}
