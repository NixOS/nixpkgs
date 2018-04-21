{ stdenv, fetchurl, ncurses, libiconv }:

stdenv.mkDerivation rec {
  name = "stfl-0.24";

  src = fetchurl {
    url = "http://www.clifford.at/stfl/${name}.tar.gz";
    sha256 = "1460d5lc780p3q38l3wc9jfr2a7zlyrcra0li65aynj738cam9yl";
  };

  buildInputs = [ ncurses libiconv ];

  buildPhase = ''
    sed -i s/gcc/cc/g Makefile
    sed -i s%ncursesw/ncurses.h%ncurses.h% stfl_internals.h
  '' + ( stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i s/-soname/-install_name/ Makefile
  '' ) + ''
    make
  '';

  installPhase = ''
    DESTDIR=$out prefix=\"\" make install

    # some programs rely on libstfl.so.0 to be present, so link it
    ln -s $out/lib/libstfl.so.0.24 $out/lib/libstfl.so.0
  '';

  meta = {
    homepage    = http://www.clifford.at/stfl/;
    description = "A library which implements a curses-based widget set for text terminals";
    maintainers = with stdenv.lib.maintainers; [ lovek323 ];
    license     = stdenv.lib.licenses.lgpl3;
    platforms   = stdenv.lib.platforms.unix;
  };
}
