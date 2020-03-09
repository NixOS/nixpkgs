{ stdenv, fetchurl, cmake, coreutils, root }:

stdenv.mkDerivation rec {
  pname = "hepmc3";
  version = "3.2.0";

  src = fetchurl {
    url = "http://hepmc.web.cern.ch/hepmc/releases/HepMC3-${version}.tar.gz";
    sha256 = "1z491x3blqs0a2jxmhzhmh4kqdw3ddcbvw69gidg4w6icdvkhcpi";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ root ];

  cmakeFlags = [
    "-DHEPMC3_ENABLE_PYTHON=OFF"
  ];

  postInstall = ''
    substituteInPlace "$out"/bin/HepMC3-config \
      --replace 'greadlink' '${coreutils}/bin/readlink' \
      --replace 'readlink' '${coreutils}/bin/readlink'
  '';

  meta = with stdenv.lib; {
    description = "The HepMC package is an object oriented, C++ event record for High Energy Physics Monte Carlo generators and simulation";
    license = licenses.gpl3;
    homepage = "http://hepmc.web.cern.ch/hepmc/";
    platforms = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
  };
}
