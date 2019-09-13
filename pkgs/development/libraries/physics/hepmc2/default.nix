{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  pname = "hepmc";
  version = "2.06.10";

  src = fetchurl {
    url = "http://hepmc.web.cern.ch/hepmc/releases/HepMC-${version}.tar.gz";
    sha256 = "190i9jlnwz1xpc495y0xc70s4zdqb9s2zdq1zkjy2ivl7ygdvpjs";
  };

  patches = [ ./in_source.patch ];
  buildInputs = [ cmake ];

  cmakeFlags = [
    "-Dmomentum:STRING=GEV"
    "-Dlength:STRING=MM"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "The HepMC package is an object oriented event record written in C++ for High Energy Physics Monte Carlo Generators";
    license     = stdenv.lib.licenses.gpl2;
    homepage    = http://hepmc.web.cern.ch/hepmc/;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ veprbl ];
  };
}
