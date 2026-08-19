# The GHC source tree, unpacked, patched, templated and autoreconf'd.
#
# Every package in the set builds out of a subdirectory of this, using the idiom
# `pkgs/development/tools/haskell/hadrian/ghc-toolchain.nix` already uses today:
#
#     src = ghcSrc;
#     postUnpack = ''sourceRoot="$sourceRoot/utils/ghc-toolchain"'';
#
# ## Why there is no `./configure` here
#
# `stable-haskell/ghc`'s Makefile runs the top-level `configure` to turn
# `*.cabal.in` into `*.cabal`. We do not, for two reasons:
#
#   o GHC's `configure` refuses to run without a bootstrap GHC
#     (`configure: error: GHC is required`) and probes a full C toolchain,
#     neither of which any of these substitutions actually needs. Depending on
#     them would make this tree per-compiler and per-platform, when its contents
#     are neither.
#
#   o Hadrian does not use `configure` for this either. `hadrian/src/Rules/
#     Generate.hs` templates the same files with plain variable interpolation,
#     and that is the authoritative list reproduced below.
#
# Every substituted variable is a pure function of the version string, so this
# derivation is `stdenvNoCC`, platform-independent, and shared by every host in
# the set. Toolchain configuration happens per-target in `./settings.nix`, via
# `ghc-toolchain`, which is the whole point of the exercise.
{
  lib,
  stdenvNoCC,
  srcOnly,
  runCommand,
  fetchurl,
  fetchgit,
  autoconf,
  automake,
  officialRelease ? null,
  gitRelease ? null,
  version,
  release_version,
  patches ? [ ],

  # `configure.ac` sets these as literals, not by probing an LLVM:
  #     LlvmMinVersion=13  # inclusive
  #     LlvmMaxVersion=21  # not inclusive
  llvmMinVersion ? "13",
  llvmMaxVersion ? "21",
}:

let
  # ---------------------------------------------------------------------------
  # The version arithmetic of `m4/fp_setup_project_version.m4`, in Nix.
  # ---------------------------------------------------------------------------
  versionComponents = lib.splitVersion release_version;
  versionMajor = lib.elemAt versionComponents 0;
  versionMinor = lib.elemAt versionComponents 1;

  # Everything after `major.minor`. Zero when absent, as the m4 has it:
  #     test -z "$ProjectPatchLevel" && ProjectPatchLevel=0
  patchLevelComponents = lib.drop 2 versionComponents;
  projectPatchLevel1 = if patchLevelComponents == [ ] then "0" else lib.head patchLevelComponents;
  projectPatchLevel2 =
    if lib.length patchLevelComponents < 2 then "0" else lib.elemAt patchLevelComponents 1;

  # Two digits for the minor version:
  #     ?)  ProjectVersionInt=${VERSION_MAJOR}0${VERSION_MINOR}
  #     ??) ProjectVersionInt=${VERSION_MAJOR}${VERSION_MINOR}
  pad2 =
    s:
    if lib.stringLength s == 1 then
      "0${s}"
    else if lib.stringLength s == 2 then
      s
    else
      throw "ghc/ng: cannot render ${s} as a two-digit version component";

  projectVersionInt = versionMajor + pad2 versionMinor;

  # "The version of the GHC package changes every day, since the patchlevel is
  # the current date. We don't want to force recompilation of the entire
  # compiler when this happens, so for GHC HEAD we omit the patchlevel."
  isHead = (lib.toInt projectPatchLevel1) > 20000000;
  projectVersionMunged =
    if isHead then "${versionMajor}.${versionMinor}" else release_version;

  # "The version used for libraries tightly coupled with GHC (e.g. ghc-internal)
  # which need a major version bump for every minor/patchlevel GHC version.
  # Example: for GHC=9.10.1, ProjectVersionForLib=9.1001"
  #
  # NB: the `??)` branch of this case in `fp_setup_project_version.m4` assigns
  # `ProjectVersionInt` rather than `ProjectVersionForLib`, which is plainly a
  # typo -- it would leave `ProjectVersionForLib` unset for any two-digit
  # patchlevel. We implement the intended behaviour, which is also what Hadrian
  # computes.
  projectVersionForLib =
    "${versionMajor}.${pad2 versionMinor}"
    + (if isHead then "00" else pad2 projectPatchLevel1);

  # ---------------------------------------------------------------------------
  # The templated files, from `hadrian/src/Rules/Generate.hs:templateRules`.
  # ---------------------------------------------------------------------------
  projectVersionSubsts = {
    ProjectVersion = release_version;
    ProjectVersionMunged = projectVersionMunged;
    ProjectVersionForLib = projectVersionForLib;
  };

  # `templateRule "<f>" $ projectVersion` for each of these.
  projectVersionFiles = [
    "compiler/ghc.cabal"
    "driver/ghci/ghci-wrapper.cabal"
    "ghc/ghc-bin.cabal"
    "utils/iserv/iserv.cabal"
    "utils/remote-iserv/remote-iserv.cabal"
    "utils/runghc/runghc.cabal"
    "utils/ghc-pkg/ghc-pkg.cabal"
    "libraries/ghc-boot/ghc-boot.cabal"
    "libraries/ghci/ghci.cabal"
    "libraries/ghc-heap/ghc-heap.cabal"
    "libraries/ghc-internal/ghc-internal.cabal"
    "libraries/ghc-experimental/ghc-experimental.cabal"
    "libraries/base/base.cabal"
    "libraries/template-haskell/template-haskell.cabal"
  ];

  # Every variable this derivation is responsible for substituting. Used by the
  # post-templating check below.
  templatedVars = [
    "ProjectVersion"
    "ProjectVersionInt"
    "ProjectVersionMunged"
    "ProjectVersionForLib"
    "ProjectPatchLevel1"
    "ProjectPatchLevel2"
    "LlvmMinVersion"
    "LlvmMaxVersion"
    "Suffix"
    "SourceRoot"
  ];

  # `--replace-quiet`, not `--replace-fail`: not every templated file mentions
  # every variable (`compiler/ghc.cabal.in` has no `@ProjectVersion@`), and
  # Hadrian's interpolation tolerates that too. Strictness is recovered
  # afterwards by `checkNoUnsubstituted`, which is a stronger check anyway --
  # it catches a variable we never knew about, which per-pattern failure
  # cannot.
  substArgs = lib.concatStringsSep " " (
    lib.mapAttrsToList (k: v: "--replace-quiet '@${k}@' ${lib.escapeShellArg v}") projectVersionSubsts
  );

  # The set of templated files differs between GHC versions -- 9.15 has no
  # `utils/iserv/iserv.cabal.in`, for instance -- so a missing `.in` is skipped
  # rather than fatal. It is still reported, because the alternative failure is
  # silent: a package that quietly keeps a stale `.cabal` from the tarball.
  substituteTemplate =
    src: dst: extra:
    ''
      if [ -e ${lib.escapeShellArg src} ]; then
        cp ${lib.escapeShellArg src} ${lib.escapeShellArg dst}
        substituteInPlace ${lib.escapeShellArg dst} ${substArgs} ${extra}
      else
        echo "note: no ${src}, skipping"
      fi
    '';

  # `rts` and `ghc-internal` are `build-type: Configure`, so Cabal -- not us --
  # runs their configure scripts at build time. We only have to make sure the
  # scripts exist. The top-level `configure` is regenerated too, because
  # `rts/configure.ac` and `ghc-internal/configure.ac` pull macros from `m4/`.
  autoreconfDirs = [
    "."
    "rts"
    "libraries/ghc-internal"
  ];

  # Bound here rather than inline so the testsuite in `passthru` can reuse the
  # very same checkout on a git release, where `testsuite/` sits in the tree.
  upstreamSrc =
    if gitRelease != null then
      fetchgit {
        url = "https://gitlab.haskell.org/ghc/ghc.git";
        inherit (gitRelease) rev sha256;
        fetchSubmodules = true;
      }
    else
      fetchurl {
        url = "https://downloads.haskell.org/ghc/${release_version}/ghc-${release_version}-src.tar.xz";
        inherit (officialRelease) sha256;
      };
in

stdenvNoCC.mkDerivation {
  pname = "ghc-source";
  inherit version;

  src = srcOnly {
    name = "ghc-${version}"; # `-source` is appended by srcOnly
    src = upstreamSrc;
    inherit patches;
  };

  nativeBuildInputs = [
    autoconf
    automake
  ];

  dontConfigure = true;
  dontBuild = true;

  # A git checkout carries Cabal's test fixtures, one of which is an
  # intentionally dangling symlink:
  #
  #   libraries/Cabal/cabal-install/tests/fixtures/project-root/cabal.project.symlink.broken
  #     -> does-not-exist
  #
  # It is the fixture for "what happens when a symlink is broken", so it is
  # supposed to dangle. Release tarballs omit it, which is why only the `head`
  # version trips this.
  dontCheckForBrokenSymlinks = true;

  postPatch = ''
    ${lib.concatMapStrings (f: substituteTemplate "${f}.in" f "") projectVersionFiles}

    # `ghc-boot-th` is templated twice from one `.in`, once as itself and once
    # as `ghc-boot-th-next`. That second copy exists so a stage can use a
    # newer `ghc-boot-th` than the one its bootstrap compiler ships, without
    # the two colliding in a package db.
    ${substituteTemplate "libraries/ghc-boot-th/ghc-boot-th.cabal.in"
      "libraries/ghc-boot-th/ghc-boot-th.cabal"
      "--replace-quiet '@Suffix@' '' --replace-quiet '@SourceRoot@' '.'"
    }
    mkdir -p libraries/ghc-boot-th-next
    cp libraries/ghc-boot-th/LICENSE libraries/ghc-boot-th/changelog.md \
      libraries/ghc-boot-th-next/
    ${substituteTemplate "libraries/ghc-boot-th/ghc-boot-th.cabal.in"
      "libraries/ghc-boot-th-next/ghc-boot-th-next.cabal"
      "--replace-quiet '@Suffix@' '-next' --replace-quiet '@SourceRoot@' '../ghc-boot-th'"
    }

    cp rts/include/ghcversion.h.in rts/include/ghcversion.h
    substituteInPlace rts/include/ghcversion.h \
      --replace-quiet '@ProjectVersion@' ${lib.escapeShellArg release_version} \
      --replace-quiet '@ProjectVersionInt@' ${lib.escapeShellArg projectVersionInt} \
      --replace-quiet '@ProjectPatchLevel1@' ${lib.escapeShellArg projectPatchLevel1} \
      --replace-quiet '@ProjectPatchLevel2@' ${lib.escapeShellArg projectPatchLevel2}

    # Hadrian renders these with `.` replaced by `,`, because the file spells
    # them as Haskell version tuples.
    cp compiler/GHC/CmmToLlvm/Version/Bounds.hs.in compiler/GHC/CmmToLlvm/Version/Bounds.hs
    substituteInPlace compiler/GHC/CmmToLlvm/Version/Bounds.hs \
      --replace-quiet '@LlvmMinVersion@' ${lib.escapeShellArg (builtins.replaceStrings [ "." ] [ "," ] llvmMinVersion)} \
      --replace-quiet '@LlvmMaxVersion@' ${lib.escapeShellArg (builtins.replaceStrings [ "." ] [ "," ] llvmMaxVersion)}


    # Recover the strictness that `--replace-quiet` gave up. A blanket
    # `@[A-Za-z]*@` sweep is not usable here: `.cabal` descriptions are Haddock,
    # and `@base@`/`@ghc-experimental@`/`@ghci@` in prose are monospace markup,
    # not variables. So check for the variables we actually know about, in every
    # file we templated.
    for f in ${lib.escapeShellArgs (
      projectVersionFiles
      ++ [
        "libraries/ghc-boot-th/ghc-boot-th.cabal"
        "libraries/ghc-boot-th-next/ghc-boot-th-next.cabal"
        "rts/include/ghcversion.h"
        "compiler/GHC/CmmToLlvm/Version/Bounds.hs"
      ]
    )}; do
      [ -e "$f" ] || continue
      if grep -nE '@(${lib.concatStringsSep "|" templatedVars})@' "$f"; then
        echo "ghc/ng: unsubstituted variable(s) left in $f (above)" >&2
        exit 1
      fi
    done
    # The one substantive thing GHC's top-level `configure` does besides
    # templating: fan a handful of files out to the packages whose .cabal files
    # claim them as their own sources. `configure.ac:576-609`, in full.
    #
    # These are `ln -f` upstream. `compiler/ghc.cabal` explains why hard links
    # rather than symlinks -- "safer for Windows, where symlinks do not work out
    # of the box, so we can't just commit some in git" -- and `utils/fs/README`
    # says the same of its own: "This file is copied across the build-system by
    # configure." We copy, since the unpacked tree may span devices.
    #
    # Miss any of these and the failure is a long way from the cause: a package
    # reports a missing header that is plainly present elsewhere in the tree.

    # RTS headers the compiler compiles against.
    cp -f rts/include/rts/Bytecodes.h compiler/
    cp -f rts/include/rts/storage/ClosureTypes.h compiler/
    cp -f rts/include/rts/storage/FunTypes.h compiler/
    cp -f rts/include/stg/MachRegs.h compiler/
    mkdir -p compiler/MachRegs
    for arch in arm32 arm64 loongarch64 ppc riscv64 s390x wasm32 x86; do
      cp -f "rts/include/stg/MachRegs/$arch.h" "compiler/MachRegs/$arch.h"
    done

    # The `fs` shim, shared by everything that does file IO portably.
    cp -f utils/fs/fs.c utils/fs/fs.h utils/unlit/
    cp -f utils/fs/fs.c utils/fs/fs.h rts/
    cp -f utils/fs/fs.h libraries/ghc-internal/include/
    cp -f utils/fs/fs.c libraries/ghc-internal/cbits/

    # Driver helpers shared between the wrapper and ghci.
    for f in getLocation.c getLocation.h isMinTTY.c isMinTTY.h cwrapper.c cwrapper.h; do
      cp -f "driver/utils/$f" driver/ghci/
    done

    for d in ${lib.escapeShellArgs autoreconfDirs}; do
      echo "running autoreconf in $d"
      ( cd "$d" && autoreconf )
    done

    # autoreconf leaves a `configure~` beside each script it regenerates: dead
    # weight in the output, and confusing to anyone grepping the tree since it
    # is a copy of the pre-regeneration script.
    find . -name 'configure~' -delete
  '';

  installPhase = ''
    runHook preInstall
    cp -r . "$out"
    runHook postInstall
  '';

  passthru = {
    # GHC's testsuite, as a tree with `driver/`, `tests/` and `mk/` at the top.
    #
    # A release publishes it as a *separate* tarball -- `-src.tar.xz` contains
    # no `testsuite/` at all -- while a git checkout carries it inline. Kept out
    # of `ghcSrc` proper so that adding it never rebuilds the compiler.
    testsuiteSrc =
      if gitRelease != null then
        runCommand "ghc-testsuite-${version}" { } ''
          cp -r ${upstreamSrc}/testsuite "$out"
          chmod -R u+w "$out"
        ''
      else
        # The tarball unpacks to `ghc-<version>/testsuite/`, so `srcOnly` leaves
        # a `testsuite` directory inside its output while the git branch above
        # produces the directory itself. Normalised here so consumers see one
        # layout: `$out` *is* the testsuite, with `driver/`, `tests/` and `mk/`
        # at its top.
        runCommand "ghc-testsuite-${version}" { } ''
          cp -r ${
            srcOnly {
              name = "ghc-testsuite-${version}";
              src = fetchurl {
                url = "https://downloads.haskell.org/ghc/${release_version}/ghc-${release_version}-testsuite.tar.xz";
                sha256 = officialRelease.testsuiteSha256;
              };
            }
          }/testsuite "$out"
          chmod -R u+w "$out"
        '';

    # The undecorated upstream version (`9.15.20260322`), as distinct from this
    # derivation's `version`, which carries nixpkgs' `-unstable-<date>` suffix
    # for git snapshots. GHC's own `cProjectVersion` and every library filename
    # it produces use the undecorated one, so anything that has to agree with
    # the compiler must use this.
    inherit release_version;

    inherit
      projectVersionInt
      projectVersionMunged
      projectVersionForLib
      projectPatchLevel1
      projectPatchLevel2
      ;
  };

  preferLocalBuild = true;

  meta = {
    description = "GHC ${version} source tree, templated and autoreconf'd";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
}
