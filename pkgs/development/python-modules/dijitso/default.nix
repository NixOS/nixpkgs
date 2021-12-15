{ stdenv
, lib
, fetchFromBitbucket
, buildPythonPackage
, numpy
, six
, pytestCheckHook
, dolfin
}:

buildPythonPackage rec {
  pname = "dijitso";
  inherit (dolfin) version;

  src = fetchFromBitbucket {
    owner = "fenics-project";
    repo = "dijitso";
    rev = version;
    sha256 = "0wffd8lphszj678xn9w45k4jr964g55awfghv0i9vln776gpsbfp";
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
