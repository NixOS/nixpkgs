{stdenv, fetchurl, gfortran, readline, ncurses, perl, flex, texinfo, qhull,
libX11, graphicsmagick, pcre, atlas, clapack, texLive }:

stdenv.mkDerivation rec {
  name = "octave-3.4.3";
  src = fetchurl {
    url = "mirror://gnu/octave/${name}.tar.bz2";
    sha256 = "0j61kpfbv8l8rw3r9cwcmskvvav3q2f6plqdq3lnb153jg61klcl";
  };

  buildInputs = [ gfortran readline ncurses perl flex texinfo qhull libX11
    graphicsmagick pcre clapack atlas texLive ];

  enableParallelBuilding = true;

  preConfigure = ''
    configureFlagsArray=('--with-blas=-L${atlas}/lib -lf77blas -latlas'
      '--with-lapack=-L${clapack}/lib -llapack -lf2c')
  '';
  configureFlags = [ "--enable-readline" "--enable-dl" ];
}
