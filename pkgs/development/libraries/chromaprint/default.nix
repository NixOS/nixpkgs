{ stdenv, fetchurl, cmake, fftw, boost }:

stdenv.mkDerivation rec {
  name = "chromaprint-${version}";
  version = "1.1";

  src = fetchurl {
    url = "http://bitbucket.org/acoustid/chromaprint/downloads/${name}.tar.gz";
    sha256 = "04nd8xmy4kgnpfffj6hw893f80bwhp43i01zpmrinn3497mdf53b";
  };

  buildInputs = [ cmake fftw boost ];

  meta = {
    homepage = "http://acoustid.org/chromaprint";
    description = "AcoustID audio fingerprinting library";
    license = stdenv.lib.licenses.lgpl21Plus;
  };
}
