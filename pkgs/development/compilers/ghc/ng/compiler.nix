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
  # `lib/targets/default.target`: everything the compiler knows about the
  # toolchain it emits code for. Independent of the GHC sources -- it is a probe
  # of `stdenv`, nothing more.
  targetFile = callPackage ./common/target.nix {
    inherit (toolsPkgs) ghc-toolchain-bin;
  };

  # Facts about the build rather than about the toolchain. The toolchain half
  # lives in `lib/targets/default.target` now, so this is all that is left of
  # `lib/settings.json` -- writing anything else here would be writing keys
  # nothing looks up.
  #
  # `base unit-id` is deliberately absent: it carries a hash Cabal computes at
  # build time, so `assemble.nix` reads it out of the registered package.conf
  # rather than guessing during evaluation, which would mean IFD.
  buildStateSettings = {
    # Only the vanilla way is built; see `threaded` in ./common/overlay.nix.
    "RTS ways" = "v";
    "Relative Global Package DB" = "package.conf.d";
    "unlit command" = "$topdir/../bin/unlit";

    # Booleans, not "YES"/"NO": 9.14 reads the first two with
    # `getRawBooleanSetting`, which rejects a string outright.
    #
    # This is the full list `hadrian/src/Rules/Generate.hs:generateSettings`
    # emits, which is the only authority on what belongs here. 9.14 still reads
    # `target has libm` and `target RTS linker only supports shared libraries`
    # from this file; on HEAD they have moved into `targets/default.target` and
    # nothing looks them up, but writing them costs nothing and keeping the two
    # versions the same beats a conditional.
    "target has libm" = stdenv.hostPlatform.isUnix;
    "target RTS linker only supports shared libraries" = false;
    "Support SMP" = true;
    "RTS expects libdw" = false;
  };

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
    # `ghc-boot`, `ghc-pkg` and the `ghc` library all depend on it once the
    # toolchain facts move into `targets/default.target`, so it has to be
    # registered or `ghc-pkg check` reports them broken. That is true of 9.14
    # too now that it carries the backport.
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
      inherit targetFile buildGhcPkg;
      inherit (packages) ghc-bin ghc-pkg;
    }
    // (
      if stage == "stage1" then
        {
          # stage1 ships no libraries, so it has no interpreter and no `base` to
          # take a unit-id from.
          buildStateSettings = buildStateSettings // {
            "Use interpreter" = false;
            "base unit-id" = "base";
          };
          # Build-hosted: stage1 only ever runs here.
          inherit (toolsPkgs) unlit;
        }
      else
        {
          buildStateSettings = buildStateSettings // {
            "Use interpreter" = true;
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
