{stdenv, fetchurl, gfortran, readline, ncurses, perl, flex, texinfo, qhull,
libX11}:

stdenv.mkDerivation {
  name = "octave-3.2.4";
  src = fetchurl {
    url = ftp://ftp.octave.org/pub/octave/octave-3.2.4.tar.bz2;
    sha256 = "0iyivx7qz7cvwz7qczqrl4ysqivlhn5ax92z9md0m77dqw2isis8";
  };
  buildInputs = [gfortran readline ncurses perl flex texinfo qhull libX11];
  configureFlags = "--enable-readline --enable-dl";
}
