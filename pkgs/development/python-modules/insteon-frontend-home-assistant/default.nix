{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "insteon-frontend-home-assistant";
  version = "0.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QaWRafp0901vQFMtlmFzkugNsM4PHRll+FUZlEz6E5g=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [
    "insteon_frontend"
  ];

  meta = with lib; {
    description = "The Insteon frontend for Home Assistant";
    homepage = "https://github.com/teharris1/insteon-panel";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
