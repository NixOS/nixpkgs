{ stdenv, fetchurl, libsigsegv, gettext, ncurses, readline, libX11
, libXau, libXt, pcre, zlib, libXpm, xproto, libXext, xextproto
, libffi, libffcall, coreutils }:
        
stdenv.mkDerivation rec {
  v = "2.44.1";
  name = "clisp-${v}";
  
  src = fetchurl {
    url = "mirror://gnu/clisp/release/${v}/${name}.tar.gz";
    sha256 = "0rkp6j6rih4s5d9acifh7pi4b9xfgcspif512l269dqy9qgyy4j1";
  };

  buildInputs =
    [ libsigsegv gettext ncurses readline libX11 libXau libXt pcre
      zlib libXpm xproto libXext xextproto libffi libffcall ];
 
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
  doCheck = 1;

  meta = {
    description = "ANSI Common Lisp Implementation";
    homepage = http://clisp.cons.org;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
