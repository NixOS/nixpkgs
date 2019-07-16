{ stdenv, fetchurl, cmake, coreutils, root }:

stdenv.mkDerivation rec {
  name = "hepmc3-${version}";
  version = "3.1.1";

  src = fetchurl {
    url = "http://hepmc.web.cern.ch/hepmc/releases/HepMC3-${version}.tar.gz";
    sha256 = "1fs8ha5issls886g03azpwamry1k633zjrcx51v7g7vg9nbckjrg";
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
