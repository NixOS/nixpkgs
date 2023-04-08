{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "insteon-frontend-home-assistant";
  version = "0.3.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-c4IvtTn1pLcPHKPyP0FRv3NOu1+Ie42B/Jkc7ej1Roo=";
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
