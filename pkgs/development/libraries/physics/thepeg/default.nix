{ stdenv, fetchurl, boost, fastjet, gsl, hepmc2, lhapdf, rivet, zlib }:

stdenv.mkDerivation rec {
  pname = "thepeg";
  version = "2.2.1";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/thepeg/ThePEG-${version}.tar.bz2";
    sha256 = "13x5gssv22mpa2w6i0vaalwcr57170vh3b4xrw8mrm3abqhwgav3";
  };

  buildInputs = [ boost fastjet gsl hepmc2 lhapdf rivet zlib ];

  configureFlags = [
    "--with-hepmc=${hepmc2}"
    "--with-rivet=${rivet}"
    "--without-javagui"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Toolkit for High Energy Physics Event Generation";
    homepage = "https://herwig.hepforge.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ veprbl ];
    platforms = platforms.unix;
  };
}
