{ stdenv, fetchurl, boost, fastjet, gsl, hepmc, lhapdf, rivet, zlib }:

stdenv.mkDerivation rec {
  name = "thepeg-${version}";
  version = "2.0.3";

  src = fetchurl {
    url = "http://www.hepforge.org/archive/thepeg/ThePEG-${version}.tar.bz2";
    sha256 = "0d26linwv92iq23n4gx154jvyd0lz5vg41kf4nxa01nspy7scyy5";
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
