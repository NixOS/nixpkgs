{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, toml
, pyyaml
, packaging
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dparse2";
  version = "0.6.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nexB";
    repo = pname;
    rev = version;
    hash = "sha256-1tbNW7Gy7gvMnETdAM2ahHiwbhG9qvdYZggia1+7eGo=";
  };

  propagatedBuildInputs = [
    toml
    pyyaml
    packaging
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Requries pipenv
    "tests/test_parse.py"
  ];

  pythonImportsCheck = [
    "dparse2"
  ];

  meta = with lib; {
    description = "Module to parse Python dependency files";
    homepage = "https://github.com/nexB/dparse2";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
