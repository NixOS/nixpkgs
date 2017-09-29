{ stdenv, fetchurl, boost, fastjet, gsl, hepmc, lhapdf, rivet, zlib }:

stdenv.mkDerivation rec {
  name = "thepeg-${version}";
  version = "2.1.1";

  src = fetchurl {
    url = "http://www.hepforge.org/archive/thepeg/ThePEG-${version}.tar.bz2";
    sha256 = "1082n4q036sah5r4asyl3hpcyc05cymg40dnk3jsdjgv2v0vvc71";
  };

  buildInputs = [ boost fastjet gsl hepmc lhapdf rivet zlib ];

  configureFlags = [
    "--with-hepmc=${hepmc}"
    "--without-javagui"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Toolkit for High Energy Physics Event Generation";
    license     = stdenv.lib.licenses.gpl2;
    homepage    = https://herwig.hepforge.org/;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ veprbl ];
  };
}
