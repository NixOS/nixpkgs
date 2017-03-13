# there are the following linking sets:
# - boot (not installed): without modules, only used when building clisp
# - base (default): contains readline and i18n, regexp and syscalls modules
#   by default
# - full: contains base plus modules in withModules
{ stdenv, fetchhg, libsigsegv, gettext, ncurses, readline, libX11
, libXau, libXt, pcre, zlib, libXpm, xproto, libXext, xextproto
, libffi, libffcall, automake
, coreutils
# build options
, threadSupport ? (stdenv.isi686 || stdenv.isx86_64)
, x11Support ? (stdenv.isi686 || stdenv.isx86_64)
, dllSupport ? true
, withModules ? [
    "pcre"
    "rawsock"
  ]
  ++ stdenv.lib.optionals stdenv.isLinux [ "bindings/glibc" "zlib" ]
  ++ stdenv.lib.optional x11Support "clx/new-clx"
}:

assert x11Support -> (libX11 != null && libXau != null && libXt != null
  && libXpm != null && xproto != null && libXext != null && xextproto != null);

stdenv.mkDerivation rec {
  v = "2.50pre20161201";
  name = "clisp-${v}";

  src = fetchhg {
    url = "http://hg.code.sf.net/p/clisp/clisp";
    rev = "536a48";
    sha256 = "097igsfpn8xipnjapyf5hx6smzh04v4ncskxl747xxn6pgpq813z";
  };

  inherit libsigsegv gettext coreutils;

  ffcallAvailable = stdenv.isLinux && (libffcall != null);

  nativeBuildInputs = [ automake ]; # sometimes fails otherwise
  buildInputs = [libsigsegv]
  ++ stdenv.lib.optional (gettext != null) gettext
  ++ stdenv.lib.optional (ncurses != null) ncurses
  ++ stdenv.lib.optional (pcre != null) pcre
  ++ stdenv.lib.optional (zlib != null) zlib
  ++ stdenv.lib.optional (readline != null) readline
  ++ stdenv.lib.optional (ffcallAvailable && (libffi != null)) libffi
  ++ stdenv.lib.optional ffcallAvailable libffcall
  ++ stdenv.lib.optionals x11Support [
    libX11 libXau libXt libXpm xproto libXext xextproto
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

  configureFlags = "builddir"
  + stdenv.lib.optionalString (!dllSupport) " --without-dynamic-modules"
  + stdenv.lib.optionalString (readline != null) " --with-readline"
  # --with-dynamic-ffi can only exist with --with-ffcall - foreign.d does not compile otherwise
  + stdenv.lib.optionalString (ffcallAvailable && (libffi != null)) " --with-dynamic-ffi"
  + stdenv.lib.optionalString ffcallAvailable " --with-ffcall"
  + stdenv.lib.optionalString (!ffcallAvailable) " --without-ffcall"
  + stdenv.lib.concatMapStrings (x: " --with-module=" + x) withModules
  + stdenv.lib.optionalString threadSupport " --with-threads=POSIX_THREADS";

  preBuild = ''
    sed -e '/avcall.h/a\#include "config.h"' -i src/foreign.d
    cd builddir
  '';

  postInstall =
    stdenv.lib.optionalString (withModules != [])
      (''./clisp-link add "$out"/lib/clisp*/base "$(dirname "$out"/lib/clisp*/base)"/full''
      + stdenv.lib.concatMapStrings (x: " " + x) withModules);

  NIX_CFLAGS_COMPILE = "-O0 ${stdenv.lib.optionalString (!stdenv.is64bit) "-falign-functions=4"}";

  # TODO : make mod-check fails
  doCheck = false;

  meta = {
    description = "ANSI Common Lisp Implementation";
    homepage = http://clisp.cons.org;
    maintainers = with stdenv.lib.maintainers; [raskin tohl];
    # problems on Darwin: https://github.com/NixOS/nixpkgs/issues/20062
    platforms = stdenv.lib.platforms.linux;
  };
}
