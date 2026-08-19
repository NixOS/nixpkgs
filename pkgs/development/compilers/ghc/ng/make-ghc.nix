# The whole ladder for one GHC version, from a bootstrap package set to a
# working compiler.
#
# `pkgs/top-level/haskell-packages.nix` calls this once per version, so the
# shared file stays small.
#
# ## The rungs
#
# Named for what they have rather than by stage number, as `gcc/ng` does:
#
#   toolsPkgs      bootstrap set + the build-platform programs from the GHC
#                  tree. Otherwise pristine: `ghc-toolchain-bin` wants ordinary
#                  Hackage dependencies (aeson -> vector -> doctest), and
#                  doctest is a GHC-API consumer that must not meet the 9.14
#                  `ghc` library.
#   stage1Pkgs     the compiler packages, built by the bootstrap compiler with
#                  the `+bootstrap` flags so they compile against the old `base`.
#   stage1Compiler those assembled into something that runs. It exists because
#                  the boot libraries cannot be built by the bootstrap
#                  compiler: `rts/Apply.cmm` uses `PUSH_BH_UPD_FRAME`, a
#                  built-in of *9.14's* Cmm parser.
#   stage2Pkgs     the boot libraries, compiled by `stage1Compiler`, together
#                  with the pinned Hackage core libraries. `base` lives here.
#   compiler       the shipped compiler: stage2's driver plus stage2's
#                  libraries, with a settings file describing what was built.
{
  lib,
  callPackage,
  stdenv,
  haskellLib,

  # The source tree and version metadata for this release, from ./default.nix.
  ghcVersion,

  # An existing package set to bootstrap from, on the **build** platform. The
  # tools and the stage1 compiler are built from this: they run here.
  bootPkgs,

  # The package set indexed by the platform the boot libraries are *for*. Native
  # builds pass the same set; a cross build passes the host-indexed one, which
  # is what gives stage2 a cross `stdenv` -- and so `generic-builder` an
  # `isCross` of true, and Cabal a `--with-gcc` naming the cross compiler rather
  # than the bare `gcc` on PATH.
  #
  # This is the "off by one" of the `_` convention made explicit: `_tools` and
  # `_wrappers` are build-hosted, the libraries are not.
  hostBootPkgs ? bootPkgs,
}:

let
  overlays = callPackage ./common/overlay.nix {
    inherit haskellLib;
    inherit (ghcVersion) ghcSrc packagesDir setupCabalVersion;
  };

  compose3 = a: b: c: lib.composeExtensions (lib.composeExtensions a b) c;

  # `setupCabal` here as well: `setupHaskellDepends` are resolved from
  # `buildHaskellPackages`, so a package's `Setup.hs` is compiled against *this*
  # set's Cabal, not the stage2 set's.
  toolsPkgs = bootPkgs.extend (lib.composeExtensions overlays.setupCabal overlays.tools);

  # `buildHaskellPackages` must be a set that carries the tools: the compiler
  # packages name `deriveConstants` and friends, and those are resolved out of
  # the build set.
  stage1Pkgs =
    (bootPkgs.override { buildHaskellPackages = toolsPkgs; }).extend
      (compose3 overlays.setupCabal overlays.tools overlays.stage1);

  toolchainSettings = callPackage ./common/settings.nix {
    inherit (toolsPkgs) ghc-toolchain-bin;
    inherit (ghcVersion) ghcSrc;
  };

  # Facts about the build rather than about the toolchain; see ./common/mk-settings.nix.
  # `base unit-id` is filled in by `assemble.nix` from the registered
  # package.conf, because it carries a hash Cabal computes at build time.
  buildStateSettings = {
    # Only the vanilla way is built; see `threaded` in ./common/overlay.nix.
    "RTS ways" = "v";
    "Relative Global Package DB" = "package.conf.d";
    "unlit command" = "$topdir/../bin/unlit";
    "cross compiling" = if stdenv.buildPlatform != stdenv.hostPlatform then "YES" else "NO";
    "target has libm" = if stdenv.hostPlatform.isUnix then "YES" else "NO";
    "Use inplace MinGW toolchain" = "NO";
    "Support SMP" = "YES";
    "RTS expects libdw" = "NO";
    "target RTS linker only supports shared libraries" = "NO";
  };

  stage1Compiler = callPackage ./common/assemble.nix {
    # The undecorated version: `generic-builder` derives library filenames from
    # `ghc.version` (`libHSghc-internal-...-ghc<version>.so`), and the compiler
    # names them after its own `cProjectVersion`. If the two disagree the link
    # fails with `cannot find -lHSghc-internal-...`.
    version = ghcVersion.ghcSrc.release_version;
    inherit (ghcVersion) ghcSrc;
    inherit toolchainSettings;
    # stage1 ships no libraries, so it has no interpreter and no `base` to take
    # a unit-id from.
    buildStateSettings = buildStateSettings // {
      "Use interpreter" = "NO";
      "base unit-id" = "base";
    };
    inherit (stage1Pkgs) ghc-bin ghc-pkg;
    inherit (toolsPkgs) unlit;
  };

  # Stage 2. `buildHaskellPackages` stays on the tools set: `generic-builder`
  # compiles each package's `Setup.hs` with `buildHaskellPackages`' compiler,
  # and `stage1Compiler` cannot do that -- its package database is empty, so it
  # has no `base` or `Cabal` to compile a Setup against. This is stable-haskell's
  # `--with-compiler=$(GHC1) --with-build-compiler=$(GHC0)`.
  stage2Pkgs =
    (hostBootPkgs.override {
      ghc = stage1Compiler;
      buildHaskellPackages = toolsPkgs;
      # NOT `configuration-ghc-*.nix`: that nulls the core libraries on the
      # premise that they ship with the compiler, which is the premise this
      # package set exists to break.
      compilerConfig = _: _: { };
    }).extend
      (compose3
        # First: make every package in the set name the compiler explicitly.
        # Later overlays refine specific packages on top of that.
        overlays.explicitCompilerEverywhere
        overlays.setupCabal
        (compose3 overlays.systemCxxStdLib overlays.buildTools (
          lib.composeExtensions overlays.hackageCore overlays.stage2
        )));

  # No `with stage2Pkgs;` -- `with` binds less tightly than `let`, so `ghc`
  # would resolve to the compiler being defined below rather than to the
  # library, which is an infinite recursion.
  shippedLibraries = map (n: stage2Pkgs.${n}) [
    "rts"
    "ghc-prim"
    "ghc-bignum"
    "ghc-internal"
    "base"
    "ghc-boot-th"
    "ghc-boot"
    "ghc-heap"
    "ghc-compact"
    "ghc-experimental"
    "ghc-platform"
    # From 9.15 `ghc-boot` and the `ghc` library both depend on it, so it has to
    # be registered or `ghc-pkg check` reports them broken. Harmless on 9.14,
    # where nothing depends on it.
    "ghc-toolchain"
    "template-haskell"
    "ghc"
    "ghci"
    "system-cxx-std-lib"
    "array"
    "binary"
    "bytestring"
    "containers"
    "deepseq"
    "directory"
    "exceptions"
    "filepath"
    "pretty"
    "process"
    "time"
    "transformers"
    "unix"
    "mtl"
    "parsec"
    "stm"
    "text"
    "os-string"
    "file-io"
    "semaphore-compat"
    "hpc"
    "haskeline"
    "terminfo"
    "xhtml"
    "Cabal"
    "Cabal-syntax"
  ];

  compilerBase = callPackage ./common/assemble.nix {
    version = ghcVersion.ghcSrc.release_version;
    inherit (ghcVersion) ghcSrc;
    inherit toolchainSettings;
    buildStateSettings = buildStateSettings // {
      "Use interpreter" = "YES";
      # Replaced at build time from the registered package.conf.
      "base unit-id" = "base";
    };
    inherit (stage2Pkgs) ghc-bin ghc-pkg;
    # From stage2, not `toolsPkgs`: these are shipped, so they must run on the
    # host. The build-time `unlit` is a different derivation in `_tools`, and on
    # a cross build a genuinely different binary.
    inherit (stage2Pkgs) unlit;
    # Filtered by what this release actually has: upstream moves these around.
    # 9.15 reorganised the external interpreter -- hadrian's `Packages.hs` lists
    # `iserv-proxy` and `remote-iserv` where 9.14 had a plain `utils/iserv` --
    # so naming it unconditionally breaks HEAD.
    programs = map (n: stage2Pkgs.${n}) (
      lib.filter (n: builtins.pathExists (ghcVersion.packagesDir + "/${n}")) [
      "hsc2hs"
      "hp2ps"
      "hpc-bin"
      "runghc"
      # The external interpreter. Needed for `-fexternal-interpreter`, for the
      # testsuite ext-interp way, and eventually for Template Haskell on a
      # cross compiler, where the host code cannot run on the build machine.
        "iserv"
      ]
    );
    # The stage2 `ghc-pkg` is a *host* binary. On a cross build it cannot run on
    # the build machine, so the database is maintained with the stage1
    # compiler's copy, which is build-hosted and the same GHC version. Natively
    # the two are the same program.
    buildGhcPkg = if stdenv.buildPlatform.canExecute stdenv.hostPlatform then null else stage1Compiler;
    libraries = shippedLibraries;
  };

  # Attached to the compiler rather than returned separately so it is reachable
  # as `nix-build -A haskell.compiler.ghcNG_9_14.testsuite`, which is what the
  # top level exposes. In `passthru`, so running it is never a condition of
  # building a compiler.
  testsuite = callPackage ./common/testsuite.nix {
    ghc = compilerBase;
    inherit (ghcVersion.ghcSrc) testsuiteSrc;
  };

  compiler = compilerBase.overrideAttrs (o: {
    passthru = (o.passthru or { }) // { inherit testsuite; };
  });
in
{
  inherit
    compiler
    toolsPkgs
    stage1Pkgs
    stage1Compiler
    stage2Pkgs
    shippedLibraries
    toolchainSettings
    overlays
    testsuite
    ;
}
