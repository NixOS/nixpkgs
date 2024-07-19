{ lib, stdenv, fetchurl, ncurses, libiconv }:

stdenv.mkDerivation rec {
  pname = "stfl";
  version = "0.24";

  src = fetchurl {
    url = "http://www.clifford.at/stfl/stfl-${version}.tar.gz";
    sha256 = "1460d5lc780p3q38l3wc9jfr2a7zlyrcra0li65aynj738cam9yl";
  };

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  buildInputs = [ ncurses libiconv ];

  # Silence warnings related to use of implicitly declared library functions and implicit ints.
  # TODO: Remove and/or fix with patches the next time this package is updated.
  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=implicit-function-declaration"
      "-Wno-error=implicit-int"
    ];
  };

  preBuild = ''
    sed -i s/gcc/cc/g Makefile
    sed -i s%ncursesw/ncurses.h%ncurses.h% stfl_internals.h
  '' + lib.optionalString stdenv.isDarwin ''
    sed -i s/-soname/-install_name/ Makefile
  ''
  # upstream builds shared library unconditionally. Also, it has no
  # support for cross-compilation.
  + lib.optionalString stdenv.hostPlatform.isStatic ''
    sed -i 's/all:.*/all: libstfl.a stfl.pc/' Makefile
    sed -i 's/\tar /\t${stdenv.cc.targetPrefix}ar /' Makefile
    sed -i 's/\tranlib /\t${stdenv.cc.targetPrefix}ranlib /' Makefile
    sed -i '/install -m 644 libstfl.so./d' Makefile
    sed -i '/ln -fs libstfl.so./d' Makefile
  '' ;

  installPhase = ''
    DESTDIR=$out prefix=\"\" make install
  ''
  # some programs rely on libstfl.so.0 to be present, so link it
  + lib.optionalString (!stdenv.hostPlatform.isStatic) ''
    ln -s $out/lib/libstfl.so.0.24 $out/lib/libstfl.so.0
  '';

  meta = {
    homepage = "http://www.clifford.at/stfl/";
    description = "Library which implements a curses-based widget set for text terminals";
    maintainers = with lib.maintainers; [ lovek323 ];
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.unix;
  };
}
