{ fetchurl, stdenv, octave ? null, cmake }:

stdenv.mkDerivation rec {
  name = "nlopt-${version}";
  version = "2.5.0";

  src = fetchurl {
    url = "https://github.com/stevengj/nlopt/archive/v${version}.tar.gz";
    sha256 = "1bmlsdzkw8xbigiihffyb0kdaqbyfn7dr8s5pdgavy7z05bpmpf6";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ octave ];

  configureFlags = [
    "--with-cxx"
    "--enable-shared"
    "--with-pic"
    "--without-guile"
    "--without-python"
    "--without-matlab"
  ] ++ stdenv.lib.optionals (octave != null) [
    "--with-octave"
    "M_INSTALL_DIR=$(out)/${octave.sitePath}/m"
    "OCT_INSTALL_DIR=$(out)/${octave.sitePath}/oct"
  ];

  meta = {
    homepage = "https://nlopt.readthedocs.io/en/latest/";
    description = "Free open-source library for nonlinear optimization";
    license = stdenv.lib.licenses.lgpl21Plus;
    hydraPlatforms = stdenv.lib.platforms.linux;
    broken = (octave != null);              # cannot cope with Octave 4.x
  };

}
