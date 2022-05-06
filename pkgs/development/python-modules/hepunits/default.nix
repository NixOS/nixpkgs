{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "hepunits";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-6A5hb+8oF/PGbHXcDkHtJjYkiMzgX5Stz977jgXry1g=";
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

