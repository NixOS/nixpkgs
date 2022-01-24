{ lib, stdenv, fetchurl, boost, fastjet, gsl, hepmc2, lhapdf, rivet, zlib }:

stdenv.mkDerivation rec {
  pname = "thepeg";
  version = "2.2.2";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/thepeg/ThePEG-${version}.tar.bz2";
    sha256 = "0gif4vb9lw2px2qdywqm7x0frbv0h5gq9lq36c50f2hv77a5bgwp";
  };

  buildInputs = [ boost fastjet gsl hepmc2 lhapdf rivet zlib ];

  configureFlags = [
    "--with-hepmc=${hepmc2}"
    "--with-rivet=${rivet}"
    "--without-javagui"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Toolkit for High Energy Physics Event Generation";
    homepage = "https://herwig.hepforge.org/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ veprbl ];
    platforms = platforms.unix;
  };
}
