{ stdenv
, lib
, fetchurl
, buildPythonPackage
, numpy
, six
, pytestCheckHook
, dolfin
}:

buildPythonPackage rec {
  pname = "dijitso";
  inherit (dolfin) version;

  src = fetchurl {
    url = "https://bitbucket.org/fenics-project/dijitso/downloads/dijitso-${version}.tar.gz";
    sha256 = "1ncgbr0bn5cvv16f13g722a0ipw6p9y6p4iasxjziwsp8kn5x97a";
  };

  propagatedBuildInputs =[ numpy six ];

  preCheck = ''
    export HOME=$PWD
  '';

  checkInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "test/" ];

  pythonImportsCheck = [ "dijitso" ];

  meta = with lib; {
    description = "Distributed just-in-time shared library building";
    homepage = "https://fenicsproject.org/";
    license = with licenses; [ lgpl3Plus ];
  };
}
