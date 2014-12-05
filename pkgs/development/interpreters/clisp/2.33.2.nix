{ stdenv, fetchurl, libsigsegv, gettext, ncurses, readline, libX11
, libXau, libXt, pcre, zlib, libXpm, xproto, libXext, xextproto
, libffi, libffcall, coreutils, automake, autoconf, linuxHeaders
, groff
}:
        
stdenv.mkDerivation rec {
  version = "2.33.2";
  name = "clisp-${version}";
  
  src = fetchurl {
    url = "mirror://gnu/clisp/release/${version}/${name}.tar.gz";
    sha256 = "0rqyggviixaa68n5ll092ll4a2xy4y7jraq65l0gn0hkjhjnm5zh";
  };

  buildInputs =
    [ libsigsegv gettext ncurses readline libX11 libXau libXt pcre
      zlib libXpm xproto libXext xextproto libffi libffcall 
      automake autoconf groff
    ]
    ++ (stdenv.lib.optional stdenv.isLinux linuxHeaders)
    ;

  # First, replace port 9090 (rather low, can be used)
  # with 64237 (much higher, IANA private area, not
  # anything rememberable).
  # Also remove reference to a type that disappeared from recent glibc
  # (seems the correct thing to do, found no reference to any solution)
  postPatch = ''
    sed -i 's@/bin/pwd@${coreutils}&@' src/clisp-link.in
    find . -type f | xargs sed -e 's/-lICE/-lXau &/' -i

    substituteInPlace modules/bindings/glibc/linux.lisp --replace "(def-c-type __swblk_t)" ""
  '';
  
  configureFlags =
    ''
      builddir
      --with-readline --with-ffcall --with-dynamic-ffi
      --with-module=readline --with-module=i18n --with-module=pcre
      --with-module=syscalls --with-modules=zlib --with-module=curses
    '';

  preBuild = ''
    echo Pre-build starting!
    sed -e '/avcall.h/a\#include "config.h"' -i src/foreign.d
    sed -e '/asm\/page.h/d' -i src/unix.d
    cd builddir
    ./makemake $configureFlags > Makefile
    make config.lisp
    cat config.lisp
  '';

  NIX_CFLAGS_COMPILE="-O0 -lreadline -lncursesw";

  # TODO : make mod-check fails
  doCheck = false;

  meta = {
    description = "ANSI Common Lisp Implementation";
    homepage = http://clisp.cons.org;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    branch = "2.44";
  };
}
