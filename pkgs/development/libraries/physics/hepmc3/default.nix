{ stdenv, fetchurl, cmake, coreutils, python, root }:

let
  pythonVersion = with stdenv.lib.versions; "${major python.version}${minor python.version}";
  withPython = python != null;
in

stdenv.mkDerivation rec {
  pname = "hepmc3";
  version = "3.2.0";

  src = fetchurl {
    url = "http://hepmc.web.cern.ch/hepmc/releases/HepMC3-${version}.tar.gz";
    sha256 = "1z491x3blqs0a2jxmhzhmh4kqdw3ddcbvw69gidg4w6icdvkhcpi";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ root ]
    ++ stdenv.lib.optional withPython python;

  cmakeFlags = [
    "-DHEPMC3_ENABLE_PYTHON=${if withPython then "ON" else "OFF"}"
  ] ++ stdenv.lib.optionals withPython [
    "-DHEPMC3_PYTHON_VERSIONS=${if python.isPy3k then "3.X" else "2.X"}"
    "-DHEPMC3_Python_SITEARCH${pythonVersion}=${placeholder "out"}/${python.sitePackages}"
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
