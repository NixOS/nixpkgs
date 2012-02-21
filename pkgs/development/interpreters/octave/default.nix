{stdenv, fetchurl, gfortran, readline, ncurses, perl, flex, texinfo, qhull,
libX11, graphicsmagick, pcre, liblapack, texLive, pkgconfig, mesa, fltk,
fftw, fftwSinglePrec, zlib, curl }:

stdenv.mkDerivation rec {
  name = "octave-3.4.3";
  src = fetchurl {
    url = "mirror://gnu/octave/${name}.tar.bz2";
    sha256 = "0j61kpfbv8l8rw3r9cwcmskvvav3q2f6plqdq3lnb153jg61klcl";
  };

  buildInputs = [ gfortran readline ncurses perl flex texinfo qhull libX11
    graphicsmagick pcre liblapack texLive pkgconfig mesa fltk zlib curl
    fftw fftwSinglePrec ];

  doCheck = true;

  enableParallelBuilding = true;

  configureFlags = [ "--enable-readline" "--enable-dl" ];
}
