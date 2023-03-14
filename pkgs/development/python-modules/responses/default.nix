{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytest-httpserver
, pytestCheckHook
, pythonOlder
, requests
, toml
, types-toml
, typing-extensions
, urllib3
}:

buildPythonPackage rec {
  pname = "responses";
  version = "0.22.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = pname;
    rev = version;
    hash = "sha256-VOIpowxPvYmufnj9MM/vMtZQDIOxorAhMCNK0fX/j1U=";
  };

  propagatedBuildInputs = [
    requests
    toml
    types-toml
    urllib3
  ]  ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];


  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpserver
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "responses"
  ];

  meta = with lib; {
    description = "Python module for mocking out the requests Python library";
    homepage = "https://github.com/getsentry/responses";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
