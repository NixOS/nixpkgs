{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "hepunits";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-M7mumot7OvNVFBp0kBy1qlV9zi5MmZKgow7wRDobIgY=";
  };
  nativeBuildInputs = [
    setuptools-scm
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Units and constants in the HEP system of units";
    homepage = "https://github.com/scikit-hep/hepunits";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}

