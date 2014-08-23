{ stdenv, fetchurl, libsigsegv, gettext, ncurses, readline, libX11
, libXau, libXt, pcre, zlib, libXpm, xproto, libXext, xextproto
, libffi, libffcall, coreutils }:
        
stdenv.mkDerivation rec {
  v = "2.49";
  name = "clisp-${v}";
  
  src = fetchurl {
    url = "mirror://gnu/clisp/release/${v}/${name}.tar.gz";
    sha256 = "0rp82nqp5362isl9i34rwgg04cidz7izljd9d85pqcw1qr964bxx";
  };

  buildInputs =
    [ libsigsegv gettext ncurses readline libX11 libXau libXt pcre
      zlib libXpm xproto libXext xextproto libffi libffcall ];

  patches = [ ./bits_ipctypes_to_sys_ipc.patch ]; # from Gentoo
      
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
