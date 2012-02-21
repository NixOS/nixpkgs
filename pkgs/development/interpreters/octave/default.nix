{stdenv, fetchurl, gfortran, readline, ncurses, perl, flex, texinfo, qhull,
libX11, graphicsmagick, pcre, blas, clapack, texLive }:

stdenv.mkDerivation rec {
  name = "octave-3.6.0";
  src = fetchurl {
    url = "mirror://gnu/octave/${name}.tar.bz2";
    sha256 = "1mwj5pbbdzfbmcqyk0vx6si7mh8yhayppwnb1i63v871gxy775z5";
  };

  buildInputs = [ gfortran readline ncurses perl flex texinfo qhull libX11
    graphicsmagick pcre blas clapack texLive ];

  NIX_LDFLAGS = "-lf2c"; # For clapack

  enableParallelBuilding = true;

  configureFlags = "--enable-readline --enable-dl --disable-docs";
}
