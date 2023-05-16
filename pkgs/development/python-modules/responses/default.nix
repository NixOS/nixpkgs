{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytest-httpserver
, pytestCheckHook
, pythonOlder
, pyyaml
, requests
, tomli
, tomli-w
, types-pyyaml
, types-toml
, typing-extensions
, urllib3
}:

buildPythonPackage rec {
  pname = "responses";
<<<<<<< HEAD
  version = "0.23.3";
=======
  version = "0.23.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-VJmcRMn0O+3mDwzkCwxIX7RU3/I9T9p9N8t6USWDZJQ=";
=======
    hash = "sha256-BU90nUZVqowFMn78KfbBEf59X7Q/1itvkGFdOzy4D2c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    pyyaml
    requests
    types-pyyaml
    types-toml
    urllib3
  ]  ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];


  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpserver
    pytestCheckHook
    tomli-w
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  pythonImportsCheck = [
    "responses"
  ];

  meta = with lib; {
    description = "Python module for mocking out the requests Python library";
    homepage = "https://github.com/getsentry/responses";
    changelog = "https://github.com/getsentry/responses/blob/${version}/CHANGES";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
