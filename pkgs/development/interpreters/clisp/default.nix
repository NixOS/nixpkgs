{ stdenv, fetchurl, libsigsegv, gettext, ncurses, readline, libX11
, libXau, libXt, pcre, zlib, libXpm, xproto, libXext, xextproto
, libffi, libffcall, coreutils }:

stdenv.mkDerivation rec {
  v = "2.48";
  name = "clisp-${v}";
  
  src = fetchurl {
    url = "mirror://gnu/clisp/release/${v}/${name}.tar.bz2";
    sha256 = "1hix1j7zhbn37ld46d6pi6agwxski893l1zwriwkd8jr11b3zf05";
  };

  inherit libsigsegv gettext coreutils;
  
  buildInputs =
    [ libsigsegv gettext ncurses readline libX11 libXau
      libXt pcre zlib libXpm xproto libXext xextproto libffi
      libffcall
    ];
 
  # First, replace port 9090 (rather low, can be used)
  # with 64237 (much higher, IANA private area, not
  # anything rememberable).
  patchPhase = ''
    sed -e 's@9090@64237@g' -i tests/socket.tst
    sed -i 's@/bin/pwd@${coreutils}&@' src/clisp-link.in
    find . -type f | xargs sed -e 's/-lICE/-lXau &/' -i
  '';

  configureFlags =
    ''
      --with-readline builddir --with-dynamic-ffi
      --with-module=clx/new-clx --with-module=i18n --with-module=bindings/glibc
      --with-module=pcre --with-module=rawsock --with-module=readline
      --with-module=syscalls --with-module=wildcard --with-module=zlib
    '';

  preBuild = ''
    sed -e '/avcall.h/a\#include "config.h"' -i src/foreign.d
    cd builddir
  '';

  NIX_CFLAGS_COMPILE="-O0";

  # TODO : make mod-check fails
  doCheck = false;

  meta = {
    description = "ANSI Common Lisp Implementation";
    homepage = http://clisp.cons.org;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}

