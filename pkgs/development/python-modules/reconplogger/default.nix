{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, logmatic-python
, pytestCheckHook
, pythonOlder
, pyyaml
, requests
, setuptools
, testfixtures
}:

buildPythonPackage rec {
  pname = "reconplogger";
  version = "4.14.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "omni-us";
    repo = "reconplogger";
    rev = "refs/tags/v${version}";
    hash = "sha256-VQX0Hdw4aXszkWicpCQ9/X7edHyOTqN7OtzPZROS9Z0=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    logmatic-python
    pyyaml
  ];

  passthru.optional-dependencies = {
    all = [
      flask
      requests
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    testfixtures
  ];

  pythonImportsCheck = [
    "reconplogger"
  ];

  pytestFlagsArray = [
    "reconplogger_tests.py"
  ];

  meta = with lib; {
    description = "Module to ease the standardization of logging within omni:us";
    homepage = "https://github.com/omni-us/reconplogger";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
