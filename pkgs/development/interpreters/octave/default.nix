{stdenv, fetchurl, gfortran, readline, ncurses, perl, flex, texinfo, qhull,
libX11, graphicsmagick, pcre, liblapack, texLive, pkgconfig, mesa, fltk,
fftw, fftwSinglePrec, zlib, curl, qrupdate }:

let
  version = "3.8.0";
in
stdenv.mkDerivation rec {
  name = "octave-${version}";
  src = fetchurl {
    url = "mirror://gnu/octave/${name}.tar.bz2";
    sha256 = "1yclb8p4mcx9xcjajyynxfnc5spw90lp44d84v56ksrlvp3314si";
  };

  buildInputs = [ gfortran readline ncurses perl flex texinfo qhull libX11
    graphicsmagick pcre liblapack pkgconfig mesa fltk zlib curl
    fftw fftwSinglePrec qrupdate ];

  # there is a mysterious sh: command not found
  doCheck = false;

  /* The build failed with a missing libranlib.la in hydra,
     but worked on my computer. I think they have concurrency problems */
  enableParallelBuilding = false;

  configureFlags = [ "--enable-readline" "--enable-dl" ];

  # Keep a copy of the octave tests detailed results in the output
  # derivation, because someone may care
  postInstall = ''
    cp test/fntests.log $out/share/octave/${name}-fntests.log
  '';

  passthru = {
    inherit version;
    sitePath = "share/octave/${version}/site";
  };

  meta = {
    homepage = http://octave.org/;
    license = "GPLv3+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
