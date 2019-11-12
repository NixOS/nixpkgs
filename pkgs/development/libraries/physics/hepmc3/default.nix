{ stdenv, fetchurl, cmake, coreutils, root }:

stdenv.mkDerivation rec {
  pname = "hepmc3";
  version = "3.1.2";

  src = fetchurl {
    url = "http://hepmc.web.cern.ch/hepmc/releases/HepMC3-${version}.tar.gz";
    sha256 = "1izcldnjbyn6myr7nv7b4jivf2vmdi64ng9gk1vjh998755hfcs1";
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
