{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "tecla-1.6.1";

  src = fetchurl {
    url = "http://www.astro.caltech.edu/~mcs/tecla/lib${name}.tar.gz";
    sha256 = "18crv6q5f9g0cg6ry5h9dsa10inhpslklrv20h70f58lpm3jknr1";
  };

  configureFlags = "CFLAGS=-O3 CXXFLAGS=-O3";

  meta = {
    homepage = "http://www.astro.caltech.edu/~mcs/tecla/";
    description = "Tecla command-line editing library";
    license = "as-is";

    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
