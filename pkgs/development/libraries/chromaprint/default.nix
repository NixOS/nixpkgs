{ stdenv, fetchurl, cmake, fftw, boost }:

stdenv.mkDerivation rec {
  name = "chromaprint-${version}";
  version = "0.7";

  src = fetchurl {
    url = "http://bitbucket.org/acoustid/chromaprint/downloads/${name}.tar.gz";
    sha256 = "00amjzrr4230v3014141hg8k379zpba56xsm572ab49w8kyw6ljf";
  };

  buildInputs = [ cmake fftw boost ];

  meta = {
    homepage = "http://acoustid.org/chromaprint";
    description = "AcoustID audio fingerprinting library";
    license = stdenv.lib.licenses.lgpl21Plus;
  };
}
