{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "insteon-frontend-home-assistant";
  version = "0.3.5-1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-R+P4pgKbLvf0mwpSDoujCvlJe/yS+nvSJ7ewLVOOg/0=";
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
    changelog = "https://github.com/pyinsteon/insteon-panel/releases/tag/${version}";
    description = "The Insteon frontend for Home Assistant";
    homepage = "https://github.com/pyinsteon/insteon-panel";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
