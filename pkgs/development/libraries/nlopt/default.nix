{ stdenv, fetchFromGitHub, cmake, octave ? null }:

stdenv.mkDerivation rec {
  pname = "nlopt";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "stevengj";
    repo = pname;
    rev = "v${version}";
    sha256 = "1k6x14lgyfhfqpbs7xx8mrgklp8l6jkkcs39zgi2sj3kg6n0hdc9";
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
  };

}
