{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  name = "hepmc-${version}";
  version = "2.06.09";

  src = fetchurl {
    url = "http://lcgapp.cern.ch/project/simu/HepMC/download/HepMC-${version}.tar.gz";
    sha256 = "020sc7hzy7d6d1i6bs352hdzy5zy5zxkc33cw0jhh8s0jz5281y6";
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
    homepage    = http://lcgapp.cern.ch/project/simu/HepMC/;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ veprbl ];
  };
}
