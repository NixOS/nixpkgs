{ stdenv
, lib
, fetchFromBitbucket
, buildPythonPackage
, pybind11
, dijitso
, fiat
, numpy
, six
, sympy
, ufl
, setuptools
, pytestCheckHook
, dolfin
}:

buildPythonPackage rec {
  pname = "ffc";
  inherit (dolfin) version;

  src = fetchFromBitbucket {
    owner = "fenics-project";
    repo = "ffc";
    rev = version;
    sha256 = "1192wk1sq2agr2aasxnppnh8mhmx88c5svfidly5jr558i7wch6c";
  };

  nativeBuildInputs = [
    pybind11
  ];

  propagatedBuildInputs = [
    dijitso
    fiat
    numpy
    six
    sympy
    ufl
    setuptools
  ];

  checkInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$PWD
  '';

  disabledTests = [ "test_evalute" ];

  pytestFlagsArray = [ "test/" ];

  pythonImportsCheck = [ "ffc" ];

  meta = with lib; {
    description = "A compiler for finite element variational forms";
    homepage = "https://fenicsproject.org/";
    license = with licenses; [ lgpl3Plus ];
  };
}
