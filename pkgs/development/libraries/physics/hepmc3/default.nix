{ stdenv, fetchurl, cmake, coreutils, root }:

stdenv.mkDerivation rec {
  name = "hepmc3-${version}";
  version = "3.1.0";

  src = fetchurl {
    url = "http://hepmc.web.cern.ch/hepmc/releases/HepMC3-${version}.tar.gz";
    sha256 = "12kzdqdbq7md0nn58jvilhh00yddfir65f0q2026k0ym37bfwdyd";
  };

  buildInputs = [ cmake root ];

  postInstall = ''
    substituteInPlace "$out"/bin/HepMC3-config \
      --replace 'greadlink' '${coreutils}/bin/readlink'
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "The HepMC package is an object oriented, C++ event record for High Energy Physics Monte Carlo generators and simulation";
    license     = licenses.gpl3;
    homepage    = http://hepmc.web.cern.ch/hepmc/;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
  };
}
