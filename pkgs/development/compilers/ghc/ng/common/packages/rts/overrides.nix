{
  lib,
  stdenv,
  libffi,
  python3,
  autoreconfHook,
  configurePlatformFlags,
  ghcArch,
  ghcOS,
  ...
}:
let
  # `rts/configure.ac` reads nine `CABAL_FLAG_<flag>` variables, which Cabal
  # exports when *it* runs the script for a `build-type: Configure`
  # package. We run the script ourselves (see `preConfigure` below), so we
  # have to export them ourselves too -- otherwise e.g.
  #
  #     AC_DEFINE_UNQUOTED([USE_LIBDW], [$CABAL_FLAG_libdw], ...)
  #
  # expands to `#define USE_LIBDW` with no value, and every `#if USE_LIBDW`
  # in the RTS fails with "#if with no expression".
  #
  # Cabal spells the variables with `-` replaced by `_`. These must agree
  # with the `-f` flags passed to Cabal below, or the .cabal conditionals
  # and the generated headers will disagree with each other.
  rtsFlags = {
    libm = stdenv.hostPlatform.isUnix;
    libbfd = false;
    libdw = false;
    libnuma = false;
    libzstd = false;
    static-libzstd = false;
    leading-underscore = stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isWindows;
    unregisterised = false;
    tables-next-to-code = true;
    # nixpkgs has libffi; use it rather than the bundled copy, which
    # `rts.cabal` would otherwise expect as `extra-bundled-libraries:
    # Cffi` from the separate `libffi-clib` package. With the flag on,
    # the .cabal just adds `extra-libraries: ffi`, so the library and
    # its headers have to come from the build inputs.
    use-system-libffi = true;

    # GHC ships hand-written adjustor code for exactly two architectures
    # (`rts.cabal`: `if arch(i386)` / `if arch(x86_64)`); everywhere else
    # the libffi implementation is the only one there is. hadrian decides
    # the same way, in `Settings.Packages`.
    #
    # Getting this wrong is invisible until link time, and then only in a
    # package that actually uses a `foreign import "wrapper"` -- the RTS
    # itself builds fine, and `haskeline` (via `terminfo`) is simply the
    # first thing in the boot set to want `createAdjustor`.
    libffi-adjustors = !(stdenv.hostPlatform.isx86_64 || stdenv.hostPlatform.isx86_32);

    # A GHC "way". Ways are not separate packages: `rts.cabal` declares
    #
    #     if flag(threaded)
    #       extra-library-flavours: _thr
    #
    # so a single build emits `libHSrts-<ver>-<uid>.a` *and*
    # `libHSrts-<ver>-<uid>_thr.a` under the same unit-id -- which is what
    # GHC looks for, since it selects a way by suffixing the library name.
    #
    # Turning this on is NOT sufficient on its own: Cabal then tries to
    # *install* `libHSrts-<ver>-<uid>_thr.a` without ever having built it
    #
    #     dist/build/libHSrts-1.0.3-B4plc..._thr.a: copyFile: does not exist
    #
    # so how Cabal decides to build a flavour needs working out before this
    # can be flipped. Left off so the RTS builds; `-threaded` does not
    # link until it is on. `profiling`, `debug` and `dynamic` compose the
    # same way.
    threaded = false;
  };
  cabalFlagVar = name: "CABAL_FLAG_${lib.replaceStrings [ "-" ] [ "_" ] name}";
  boolToFlag = b: if b then "1" else "0";

in
final: _: {
  # cabal2nix reads rts.cabal's `extra-libraries: c` as a nixpkgs package
  # named `c`, which does not exist -- the stdenv supplies libc. `libffi`
  # is real and needed: `ffi.h` for `include/rts/ghc_ffi.h`, and `-lffi`
  # at link time, since `use-system-libffi` is on above.
  librarySystemDepends = [ libffi ];

  # `rts` is `build-type: Configure`, and `rts/configure.ac` goes looking
  # for these:
  #
  #     AC_PATH_PROG([NM], nm)
  #     AC_PATH_PROG([OBJDUMP], objdump)
  #     AC_PATH_PROG([DERIVE_CONSTANTS], deriveConstants)
  #     AC_PATH_PROG([GENAPPLY], genapply)
  #
  # `deriveConstants --gen-header` writes `DerivedConstants.h`; `genapply`
  # writes the `AutoApply*.cmm.h` files. Under hadrian these are
  # `Rules.Generate`; here Cabal runs the configure script and we hand it
  # the tools.
  #
  # `buildHaskellPackages` explicitly, not a bare scope name: these are
  # interpolated into strings, and `__spliced` is only consulted for
  # mkDerivation dependency lists. A bare name would silently give the
  # host-target build of a program that has to run here.
  # Everything below runs the package's own configure *before* Cabal gets a
  # look in.
  #
  # `build-type: Configure` means Cabal runs `./configure` from its `postConf`
  # hook -- but its own configure step runs first, and that step checks
  # `includes: Rts.h`. `Rts.h` pulls in `ghcautoconf.h` and `ghcplatform.h`,
  # which are `autogen-includes`: they do not exist until `rts/configure` has
  # assembled them (see the tail of `rts/configure.ac`, which cats
  # `ghcplatform.h.top` and `ghcautoconf.h.autoconf` into `include/`). Left to
  # Cabal, the check fails with "Missing (or bad) header file: Rts.h" before
  # the script that would have created them ever runs.
  #
  # Hadrian sidesteps this by generating those headers itself
  # (`Rules.Generate`); we run the script.
  preConfigure = ''
    export DERIVE_CONSTANTS="${final.buildHaskellPackages.deriveConstants}/bin/deriveConstants"
    export GENAPPLY="${final.buildHaskellPackages.genapply}/bin/genapply"
  ''
  # `rts/configure.ac` reads these nine directly. Cabal exports them when
  # *it* runs the script; we run it ourselves, so without them
  # `AC_DEFINE_UNQUOTED([USE_LIBDW], [$CABAL_FLAG_libdw])` expands to a bare
  # `#define USE_LIBDW`, and every `#if USE_LIBDW` dies with "#if with no
  # expression".
  + lib.concatStringsSep "\n" (
    lib.mapAttrsToList (n: v: "  export ${cabalFlagVar n}=${boolToFlag v}") rtsFlags
  )
  + ''

    ./configure ${lib.escapeShellArgs configurePlatformFlags}
  ''
  # Three headers hadrian generates that neither `rts/configure` nor the .cabal
  # produce (`Rules.Generate`: `genEventTypes`, `genPlatformConstantsHeader`).
  # `rts.cabal` lists the first two under `install-includes` with a bare
  # `-- ^ generated` comment, which is the only hint in the package that they
  # do not exist yet.
  + ''
    python3 gen_event_types.py --event-types-defines include/rts/EventLogConstants.h
    python3 gen_event_types.py --event-types-array   include/rts/EventTypes.h
  ''
  # The third of them. deriveConstants compiles probe programs that `#include
  # PosixSource.h`, which `#include`s `ghcplatform.h` -- so this has to come
  # after `./configure` has assembled it. See GHC #18290.
  #
  # `-fcommon` because modern gcc defaults to `-fno-common`, which changes how
  # deriveConstants' probe symbols are emitted and makes it report
  # `CONTROL_GROUP_CONST_291 missing!`. hadrian passes it too, in
  # `Settings.Builders.DeriveConstants.includeCcArgs`.
  + ''
    derivedTmp=$(mktemp -d)
    "${final.buildHaskellPackages.deriveConstants}/bin/deriveConstants" \
      --gen-header \
      -o include/DerivedConstants.h \
      --tmpdir "$derivedTmp" \
      --gcc-program "$CC" \
      --gcc-flag -Iinclude \
      --gcc-flag -I. \
      --gcc-flag -fcommon \
      --nm-program "$NM" \
      --target-os "${ghcOS stdenv.hostPlatform}"
  ''
  # `rts.cabal` lists AutoApply{,_V16,_V32,_V64}.cmm in `cmm-sources`, but
  # unlike the `Jumps_V*.cmm` beside them those files are not in the tree --
  # hadrian generates them with `genapply` from the constants header
  # (`Rules.Generate`, `Settings.Builders.GenApply`). Without this the build
  # fails with `<command line>: does not exist: AutoApply.cmm`.
  + ''
    genapply='${final.buildHaskellPackages.genapply}/bin/genapply'
    "$genapply" include/DerivedConstants.h > AutoApply.cmm
  ''
  # The vector apply thunks. Which of these actually contain code is decided by
  # `Jumps.h`, which keys off `REG_XMM1`/`REG_YMM1`/`REG_ZMM1` from the
  # generated `ghcplatform.h` -- so on a target without those registers they
  # compile to nothing of their own accord, provided `./configure` was told the
  # right host.
  + ''
    for w in 16 32 64; do
      "$genapply" include/DerivedConstants.h "-V$w" > "AutoApply_V$w.cmm"
    done
  '';

  # `gen_event_types.py` and, indirectly, `deriveConstants`.
  #
  # `autoreconfHook` because `rts` is `build-type: Configure` and the
  # source tree ships `configure.ac` without a `configure`. The hook adds
  # `autoreconfPhase` to `preConfigurePhases`, which `generic-builder`
  # already uses for `compileBuildDriverPhase`, so it lands before the
  # `./configure` run in `preConfigure` above.
  libraryToolDepends = [
    python3
    autoreconfHook
  ];
  configureFlags =
    # Must agree with `rtsFlags` above.
    lib.mapAttrsToList (n: v: if v then "-f${n}" else "-f-${n}") rtsFlags
    ++ [
      # Defines hadrian passes in `Settings.Packages.rtsPackageArgs` and the
      # .cabal does not. `RtsUtils.c:printRtsInfo` reads `RtsWay` directly,
      # so without it the RTS does not compile at all -- the other macros it
      # wants (`HOST_ARCH`, `HOST_OS`, `HOST_VENDOR`,
      # `__GLASGOW_HASKELL_FULL_VERSION__`) come from the generated
      # `ghcplatform.h` and `ghcversion.h`.
      #
      # `rts_v` is the vanilla way. When more ways are built each gets its
      # own value, and the set of them is what the `RTS ways` settings entry
      # has to report.
      # GHC's own -I, not the C compiler's. When the home unit is `rts`,
      # `GHC.Unit.State.initUnits` looks for `DerivedConstants.h` in
      # `includePathsGlobal` -- "we're building the RTS!" -- and without it
      # the compiler panics with "Platform constants not available!" the
      # moment it has to compile Cmm.
      "--ghc-option=-Iinclude"
      # ... and the home unit has to actually *be* `rts` for that branch to
      # be taken. `rts.cabal` says `ghc-options: -this-unit-id rts`, but
      # Cabal appends its own hashed `-this-unit-id` afterwards and last
      # wins, so the compiler does not recognise itself as building the
      # RTS. Passing it again here puts it last.
      #
      # Verified by hand in a kept build tree: `ghc -this-unit-id rts
      # -Iinclude -c Apply.cmm` compiles, without it the compiler panics.
      "--ghc-option=-this-unit-id"
      "--ghc-option=rts"
    ]
    ++ lib.optionals stdenv.hostPlatform.isx86_64 [
      # `AutoApply_V32.cmm` and `AutoApply_V64.cmm` use 256- and 512-bit
      # vectors, and GHC refuses without the matching ISA flag:
      #
      #     ghc: sorry! 256-bit wide vectors require -mavx2
      #
      # hadrian applies these per file
      # (`Settings.Packages`: `inputs ["**/AutoApply_V32.cmm"] ? "-mavx2"`),
      # and stable-haskell uses Cabal per-file options -- `AutoApply_V32.cmm
      # (-mavx2)` -- which is one of their Cabal patches, not upstream
      # syntax.
      #
      # Library-wide is equivalent here: these are the only RTS Cmm sources
      # that use vectors at all, so the code GHC emits is the same. It does
      # *permit* wider instructions elsewhere in the RTS rather than
      # forbidding them, which is the one difference from hadrian.
      "--ghc-option=-mavx2"
      "--ghc-option=-mavx512f"
    ]
    ++ [
      # These are architecture-independent and must stay outside the x86_64
      # block above -- without them an aarch64 cross build fails with
      # `RtsWay undeclared`.
      ''--ghc-option=-optc-DRtsWay="rts_v"''
      "--ghc-option=-optc-DCOMPILING_RTS"
      "--ghc-option=-optc-DFS_NAMESPACE=rts"
    ];
}
