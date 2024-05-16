{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, flaky
, pyjwt
, pytestCheckHook
, pythonOlder
, requests
, responses
, setuptools
, typing-extensions
}:

buildPythonPackage rec {
  pname = "globus-sdk";
  version = "3.39.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "globus";
    repo = "globus-sdk-python";
    rev = "refs/tags/${version}";
    hash = "sha256-DjGwwpXzYRq5/hiUs/l8kD/yA58vbhvrKirKDlWoAmY=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    cryptography
    requests
    pyjwt
  ] ++ lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  checkInputs = [
    flaky
    responses
  ];

  pythonImportsCheck = [
    "globus_sdk"
  ];

  meta = with lib; {
    description = "Interface to Globus REST APIs, including the Transfer API and the Globus Auth API";
    homepage =  "https://github.com/globus/globus-sdk-python";
    changelog = "https://github.com/globus/globus-sdk-python/releases/tag/${version}";
    license = licenses.asl20;
  };
}
