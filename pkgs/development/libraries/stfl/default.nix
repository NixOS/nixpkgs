{ lib, stdenv, fetchurl, ncurses, libiconv }:

stdenv.mkDerivation rec {
  pname = "stfl";
  version = "0.24";

  src = fetchurl {
    url = "http://www.clifford.at/stfl/stfl-${version}.tar.gz";
    sha256 = "1460d5lc780p3q38l3wc9jfr2a7zlyrcra0li65aynj738cam9yl";
  };

  buildInputs = [ ncurses libiconv ];

  preBuild = ''
    sed -i s/gcc/cc/g Makefile
    sed -i s%ncursesw/ncurses.h%ncurses.h% stfl_internals.h
  '' + lib.optionalString stdenv.isDarwin ''
    sed -i s/-soname/-install_name/ Makefile
  '';

  installPhase = ''
    DESTDIR=$out prefix=\"\" make install

    # some programs rely on libstfl.so.0 to be present, so link it
    ln -s $out/lib/libstfl.so.0.24 $out/lib/libstfl.so.0
  '';

  meta = {
    homepage = "http://www.clifford.at/stfl/";
    description = "A library which implements a curses-based widget set for text terminals";
    maintainers = with lib.maintainers; [ lovek323 ];
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.unix;
  };
}
