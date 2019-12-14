{ stdenv, fetchurl, boost, fastjet, gsl, hepmc2, lhapdf, rivet, zlib }:

stdenv.mkDerivation rec {
  pname = "thepeg";
  version = "2.1.6";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/thepeg/ThePEG-${version}.tar.bz2";
    sha256 = "0krz6psr69kn48xkgr0mjadmzvq572mzn02inlasiz3bf61izrf1";
  };

  buildInputs = [ boost fastjet gsl hepmc2 lhapdf rivet zlib ];

  configureFlags = [
    "--with-hepmc=${hepmc2}"
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
