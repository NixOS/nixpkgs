# A GHC assembled out of one rung's packages.
#
# Two get built, and they differ only in what they ship:
#
#   stage1  the driver alone, with an empty package database. It exists to
#           compile the boot libraries, which the bootstrap compiler cannot.
#   stage2  the shipped compiler: the same driver built against the new `base`,
#           plus the boot libraries registered into its database.
#
# Like ./package-set.nix, nothing here reaches for a package set of its own --
# `packages` and `toolsPkgs` arrive as arguments, so the caller takes them from
# `buildPackages.haskell.packages.*` and the chain stays late-bound.
{
  lib,
  stdenv,
  callPackage,

  # The release, from ./default.nix.
  ghcVersion,

  # Which compiler. See above.
  stage,

  # The rung this compiler is made of: `packages."ghcNG-X_YY-stage1"` for a
  # stage1 compiler, `packages."ghcNG-X_YY"` for the shipped one.
  packages,

  # The build-platform programs. `unlit` is taken from here for stage1, which
  # only ever runs on the build machine; the shipped compiler takes its own.
  toolsPkgs,

  # A build-hosted compiler for maintaining the package database, needed when
  # the `ghc-pkg` we ship is a host binary that cannot run here. Natively the
  # shipped one runs, and this is `null`. See ./common/assemble.nix.
  buildGhcPkg ? null,
}:

let
  toolchainSettings = callPackage ./common/settings.nix {
    inherit (toolsPkgs) ghc-toolchain-bin;
    inherit (ghcVersion) ghcSrc;
  };

  inherit (ghcVersion) typedSettings;

  # Facts about the build rather than about the toolchain; see
  # ./common/mk-settings.nix. `base unit-id` is deliberately absent -- it
  # carries a hash Cabal computes at build time, so `assemble.nix` reads it out
  # of the registered package.conf rather than guessing during evaluation.
  buildStateSettings = {
    # Only the vanilla way is built; see `threaded` in ./common/overlay.nix.
    "RTS ways" = "v";
    "Relative Global Package DB" = "package.conf.d";
    "unlit command" = "$topdir/../bin/unlit";
  }
  # A tree that reads `settings.json` has had the toolchain facts moved into
  # `lib/targets/default.target`, so these are no longer read from here at
  # all. Keeping them would be writing keys nothing looks up.
  // lib.optionalAttrs (!typedSettings) {
    "cross compiling" = if stdenv.buildPlatform != stdenv.hostPlatform then "YES" else "NO";
    "target has libm" = if stdenv.hostPlatform.isUnix then "YES" else "NO";
    "Use inplace MinGW toolchain" = "NO";
    "Support SMP" = "YES";
    "RTS expects libdw" = "NO";
    "target RTS linker only supports shared libraries" = "NO";
  };

  # `Use interpreter` is the one boolean the compiler still reads from the
  # settings file. Typed trees read it with `getRawBooleanSetting`, which
  # rejects a string outright, so the two spellings are not interchangeable.
  useInterpreter = b: if typedSettings then b else (if b then "YES" else "NO");

  # The libraries the shipped compiler registers. Named rather than taken
  # wholesale, because the set now contains all of Hackage.
  shippedLibraryNames = [
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

  # Filtered by what this release actually has: upstream moves these around.
  # 9.15 reorganised the external interpreter -- hadrian's `Packages.hs` lists
  # `iserv-proxy` and `remote-iserv` where 9.14 had a plain `utils/iserv` -- so
  # naming it unconditionally breaks HEAD.
  programNames = lib.filter (n: builtins.pathExists (ghcVersion.packagesDir + "/${n}")) [
    "hsc2hs"
    "hp2ps"
    "hpc-bin"
    "runghc"
    # The external interpreter. Needed for `-fexternal-interpreter`, for the
    # testsuite ext-interp way, and eventually for Template Haskell on a cross
    # compiler, where the host code cannot run on the build machine.
    "iserv"
  ];

  base = callPackage ./common/assemble.nix (
    {
      # The undecorated version: `generic-builder` derives library filenames
      # from `ghc.version` (`libHSghc-internal-...-ghc<version>.so`), and the
      # compiler names them after its own `cProjectVersion`. If the two
      # disagree the link fails with `cannot find -lHSghc-internal-...`.
      version = ghcVersion.ghcSrc.release_version;
      inherit (ghcVersion) ghcSrc;
      inherit toolchainSettings buildGhcPkg typedSettings;
      inherit (packages) ghc-bin ghc-pkg;
    }
    // (
      if stage == "stage1" then
        {
          # stage1 ships no libraries, so it has no interpreter and no `base` to
          # take a unit-id from.
          buildStateSettings = buildStateSettings // {
            "Use interpreter" = useInterpreter false;
            "base unit-id" = "base";
          };
          # Build-hosted: stage1 only ever runs here.
          inherit (toolsPkgs) unlit;
        }
      else
        {
          buildStateSettings = buildStateSettings // {
            "Use interpreter" = useInterpreter true;
            # Replaced at build time from the registered package.conf.
            "base unit-id" = "base";
          };
          # From this rung, not `toolsPkgs`: these are shipped, so they must run
          # on the host. The build-time `unlit` is a different derivation, and on
          # a cross build a genuinely different binary.
          inherit (packages) unlit;
          programs = map (n: packages.${n}) programNames;
          libraries = map (n: packages.${n}) shippedLibraryNames;
        }
    )
  );

  # Attached to the compiler rather than exposed separately so it is reachable
  # as `nix-build -A haskell.compiler."ghcNG-9_14".testsuite`. In `passthru`, so
  # running it is never a condition of building a compiler.
  testsuite = callPackage ./common/testsuite.nix {
    ghc = base;
    inherit (ghcVersion.ghcSrc) testsuiteSrc;
  };
in

if stage == "stage1" then
  base
else
  base.overrideAttrs (o: {
    passthru = (o.passthru or { }) // {
      inherit testsuite;
    };
  })
