# `libraries/ghc-internal/configure.ac` probes a header of its own:
#
#     AC_CHECK_TYPE([struct MD5Context], [], [AC_MSG_ERROR([internal error])],
#                   [#include "include/md5.h"])
#
# That path is relative, and Cabal runs `./configure` from `dist/build`,
# not from the package directory -- so it fails with
#
#     fatal error: include/md5.h: No such file or directory
#
# and the script reports the singularly unhelpful `configure: error:
# internal error`. hadrian runs configure in the package directory;
# stable-haskell carries a Cabal patch ("rewrite ./configure script
# invocation") that changes this.
#
# A quoted include searches `-I` paths after the current directory, so
# pointing CPPFLAGS at the package directory is enough and needs no patch.
{
  lib,
  configurePlatformFlags,
  autoreconfHook,
  ...
}:
final: _: {
  # Same as rts: `c` is libc, supplied by the stdenv.
  librarySystemDepends = [ ];

  # `build-type: Configure` with a `configure.ac` and no `configure`: the
  # source tree ships the input, this generates the script. The hook adds
  # `autoreconfPhase` to `preConfigurePhases`, which `generic-builder`
  # already uses for `compileBuildDriverPhase`, so it lands before the
  # `./configure` in `preConfigure` below.
  libraryToolDepends = [ autoreconfHook ];

  preConfigure = ''
    export CPPFLAGS="$CPPFLAGS -I$PWD"

    # Run it here, in the package directory, before Cabal runs it from
    # `dist/build`. It is not only the *inputs* that are resolved relative
    # to the working directory -- `AC_CONFIG_FILES([ghc-internal.buildinfo
    # include/HsIntegerGmp.h])` writes its *outputs* there too, and Cabal
    # looks for the buildinfo in the package directory. Without this the
    # package configures happily and then builds nothing at all:
    #
    #     Warning: No executables and no library found. Nothing to do.
    #     Package contains no library to register: ghc-internal-9.1401.0
    ./configure ${lib.escapeShellArgs configurePlatformFlags}

    # `GHC.Internal.Prim` and `GHC.Internal.PrimopWrappers` are generated,
    # not shipped -- hadrian makes them with `genprimopcode` from the
    # CPP-processed primops table (`Rules.Generate.genPrimopCode`). Without
    # them Cabal stops at
    #
    #     can't find source for GHC/Internal/Prim in src, dist/build/autogen
    #
    # The preprocessing matches what `compiler/Setup.hs` does for the
    # compiler's own `primop-*.hs-incl` files: the Haskell CPP flags from
    # the settings file, then `-P -x c`.
    primopsTxt=$(mktemp)
    "$CC" -E -undef -traditional -P -x c \
      -I../../compiler ../../compiler/GHC/Builtin/primops.txt.pp \
      > "$primopsTxt"

    genprimopcode='${final.buildHaskellPackages.genprimopcode}/bin/genprimopcode'
    mkdir -p src/GHC/Internal

    # `PrimopWrappers` is generated in every version we support.
    "$genprimopcode" --make-haskell-wrappers < "$primopsTxt" > src/GHC/Internal/PrimopWrappers.hs

    # `Prim` is generated in 9.14 but is a real source file in 9.15, where
    # `genprimopcode` no longer even has `--make-haskell-source` -- passing
    # it just prints the usage message and exits. Keyed on whether the file
    # is already there rather than on a version test, so this needs no
    # revisiting when it changes again.
    if [ ! -e src/GHC/Internal/Prim.hs ]; then
      "$genprimopcode" --make-haskell-source < "$primopsTxt" > src/GHC/Internal/Prim.hs
    fi
  '';
}
