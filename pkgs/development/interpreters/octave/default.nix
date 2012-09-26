{stdenv, fetchurl, gfortran, readline, ncurses, perl, flex, texinfo, qhull,
libX11, graphicsmagick, pcre, liblapack, texLive, pkgconfig, mesa, fltk,
fftw, fftwSinglePrec, zlib, curl, qrupdate }:

stdenv.mkDerivation rec {
  name = "octave-3.6.2";
  src = fetchurl {
    url = "mirror://gnu/octave/${name}.tar.bz2";
    sha256 = "1bn48ldhx585iyrylnz59b6mb3wlpvmz2i3ri8q75s5ys29rpdhb";
  };

  buildInputs = [ gfortran readline ncurses perl flex texinfo qhull libX11
    graphicsmagick pcre liblapack texLive pkgconfig mesa fltk zlib curl
    fftw fftwSinglePrec qrupdate ];

  doCheck = true;

  /* The build failed with a missing libranlib.la in hydra,
     but worked on my computer. I think they have concurrency problems */
  enableParallelBuilding = false;

  configureFlags = [ "--enable-readline" "--enable-dl" ];

  # Keep a copy of the octave tests detailed results in the output
  # derivation, because someone may care
  postInstall = ''
    cp test/fntests.log $out/share/octave/${name}-fntests.log
  '';

  meta = {
    homepage = http://octave.org/;
    license = "GPLv3+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
