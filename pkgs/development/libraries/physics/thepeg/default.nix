{ stdenv, fetchurl, boost, fastjet, gsl, hepmc, lhapdf, rivet, zlib }:

stdenv.mkDerivation rec {
  name = "thepeg-${version}";
  version = "2.1.3";

  src = fetchurl {
    url = "http://www.hepforge.org/archive/thepeg/ThePEG-${version}.tar.bz2";
    sha256 = "030wpk78mwb56iph5iqmblsxgzpydsa25bbkv07bihihfm8gds0n";
  };

  buildInputs = [ boost fastjet gsl hepmc lhapdf rivet zlib ];

  configureFlags = [
    "--with-hepmc=${hepmc}"
    "--with-rivet=${rivet}"
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
