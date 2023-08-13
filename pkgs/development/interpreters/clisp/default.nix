# there are the following linking sets:
# - boot (not installed): without modules, only used when building clisp
# - base (default): contains readline and i18n, regexp and syscalls modules
#   by default
# - full: contains base plus modules in withModules
{ lib, stdenv, fetchurl, libsigsegv, gettext, ncurses, readline, libX11
, libXau, libXt, pcre, zlib, libXpm, xorgproto, libXext
, libffi
, libffcall
, coreutils
# build options
, threadSupport ? stdenv.hostPlatform.isx86
, x11Support ? stdenv.hostPlatform.isx86
, dllSupport ? true
, withModules ? [
    "pcre"
    "rawsock"
  ]
  ++ lib.optionals stdenv.isLinux [ "bindings/glibc" "zlib" "wildcard" ]
  ++ lib.optional x11Support "clx/new-clx"
}:

assert x11Support -> (libX11 != null && libXau != null && libXt != null
  && libXpm != null && xorgproto != null && libXext != null);

stdenv.mkDerivation rec {
  version = "2.49";
  pname = "clisp";

  src = fetchurl {
    url = "mirror://gnu/clisp/release/${version}/clisp-${version}.tar.bz2";
    sha256 = "8132ff353afaa70e6b19367a25ae3d5a43627279c25647c220641fed00f8e890";
  };

  inherit libsigsegv gettext coreutils;

  ffcallAvailable = stdenv.isLinux && (libffcall != null);

  buildInputs = [libsigsegv]
  ++ lib.optional (gettext != null) gettext
  ++ lib.optional (ncurses != null) ncurses
  ++ lib.optional (pcre != null) pcre
  ++ lib.optional (zlib != null) zlib
  ++ lib.optional (readline != null) readline
  ++ lib.optional (ffcallAvailable && (libffi != null)) libffi
  ++ lib.optional ffcallAvailable libffcall
  ++ lib.optionals x11Support [
    libX11 libXau libXt libXpm xorgproto libXext
  ];

  patches = [
    ./bits_ipctypes_to_sys_ipc.patch # from Gentoo
    # The cfree alias no longer exists since glibc 2.26
    ./remove-cfree-binding.patch
  ];

  # First, replace port 9090 (rather low, can be used)
  # with 64237 (much higher, IANA private area, not
  # anything rememberable).
  # Also remove reference to a type that disappeared from recent glibc
  # (seems the correct thing to do, found no reference to any solution)
  postPatch = ''
    sed -e 's@9090@64237@g' -i tests/socket.tst
    sed -i 's@/bin/pwd@${coreutils}&@' src/clisp-link.in
    find . -type f | xargs sed -e 's/-lICE/-lXau &/' -i

    substituteInPlace modules/bindings/glibc/linux.lisp --replace "(def-c-type __swblk_t)" ""
  '';

  configureFlags = [ "builddir" ]
  ++ lib.optional (!dllSupport) "--without-dynamic-modules"
  ++ lib.optional (readline != null) "--with-readline"
  # --with-dynamic-ffi can only exist with --with-ffcall - foreign.d does not compile otherwise
  ++ lib.optional (ffcallAvailable && (libffi != null)) "--with-dynamic-ffi"
  ++ lib.optional ffcallAvailable "--with-ffcall"
  ++ lib.optional (!ffcallAvailable) "--without-ffcall"
  ++ builtins.map (x: "--with-module=" + x) withModules
  ++ lib.optional threadSupport "--with-threads=POSIX_THREADS";

  preBuild = ''
    sed -e '/avcall.h/a\#include "config.h"' -i src/foreign.d
    cd builddir
  '';

  # Fails to build in parallel due to missing gnulib header dependency used in charstrg.d:
  #   ../src/charstrg.d:319:10: fatal error: uniwidth.h: No such file or directory
  enableParallelBuilding = false;

  postInstall =
    lib.optionalString (withModules != [])
      (''./clisp-link add "$out"/lib/clisp*/base "$(dirname "$out"/lib/clisp*/base)"/full''
      + lib.concatMapStrings (x: " " + x) withModules);

  env.NIX_CFLAGS_COMPILE = "-O0 ${lib.optionalString (!stdenv.is64bit) "-falign-functions=4"}";

  # TODO : make mod-check fails
  doCheck = false;

  meta = {
    description = "ANSI Common Lisp Implementation";
    homepage = "http://clisp.cons.org";
    maintainers = lib.teams.lisp.members;
    platforms = lib.platforms.unix;
    # problems on Darwin: https://github.com/NixOS/nixpkgs/issues/20062
    broken = stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isAarch64;
    license = lib.licenses.gpl2;
  };
}
