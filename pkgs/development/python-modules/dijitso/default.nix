{ stdenv
, lib
, fetchurl
, python3Packages
, dolfin
}:

python3Packages.buildPythonPackage rec {
  pname = "dijitso";
  inherit (dolfin) version;

  src = fetchurl {
    url = "https://bitbucket.org/fenics-project/dijitso/downloads/dijitso-${version}.tar.gz";
    sha256 = "1ncgbr0bn5cvv16f13g722a0ipw6p9y6p4iasxjziwsp8kn5x97a";
  };

  propagatedBuildInputs = with python3Packages; [ numpy six ];
  checkInputs = with python3Packages; [ pytest ];

  preCheck = ''
    export HOME=$PWD
  '';

  checkPhase = ''
    runHook preCheck
    py.test test/
    runHook postCheck
  '';

  pythonImportsCheck = [ "dijitso" ];

  meta = with lib; {
    description = "Distributed just-in-time shared library building";
    homepage = "https://fenicsproject.org/";
    license = with licenses; [ lgpl3Plus ];
  };
}
