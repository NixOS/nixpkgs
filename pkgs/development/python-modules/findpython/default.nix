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
  version = "0.2.2";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gFV5YcBM8cjEukyjrHz3bsJ/qSeIpq9Cy3AeNFDElDA=";
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
