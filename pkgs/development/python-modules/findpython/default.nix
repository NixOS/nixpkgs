{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# build time
, pdm-pep517

# runtime
, packaging

# tests
, pytestCheckHook
}:

let
  pname = "findpython";
  version = "0.2.0";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wgme4LcfwnFLZPaP0fQLwO5H9J3+lUf7ZNfLzAL+CHE=";
  };

  nativeBuildInputs = [
    pdm-pep517
  ];

  propagatedBuildInputs = [
    packaging
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "findpython"
  ];

  meta = with lib; {
    description = "A utility to find python versions on your system";
    homepage = "https://github.com/frostming/findpython";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
