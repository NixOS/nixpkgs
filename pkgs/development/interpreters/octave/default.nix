{stdenv, fetchurl, gfortran, readline, ncurses, perl, flex, texinfo, qhull}:

stdenv.mkDerivation {
  name = "octave-3.0.4";
  src = fetchurl {
    url = ftp://ftp.octave.org/pub/octave/octave-3.0.4.tar.bz2;
    sha256 = "1rkpzig0r0zrm73avxgai0zqkz9hv4js57i1xxdzcm22qw22szaj";
  };
  buildInputs = [gfortran readline ncurses perl flex texinfo qhull];
  configureFlags = "--enable-readline --enable-dl";
}
