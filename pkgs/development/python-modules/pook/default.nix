{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, furl
, hatchling
, jsonschema
, pytest-asyncio
, pytest-httpbin
, pytestCheckHook
, pytest_7
, pythonOlder
, requests
, xmltodict
}:

buildPythonPackage rec {
  pname = "pook";
  version = "1.4.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "h2non";
    repo = "pook";
    rev = "refs/tags/v${version}";
    hash = "sha256-sdfkMvPSlVK7EoDUEuJbiuocOjGJygqiCiftrsjnDhU=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    aiohttp
    furl
    jsonschema
    requests
    xmltodict
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpbin
    (pytestCheckHook.override { pytest = pytest_7; })
  ];

  pythonImportsCheck = [
    "pook"
  ];

  disabledTestPaths = [
    # Don't test integrations
    "tests/integration/"
    # Tests require network access
    "tests/unit/interceptors/"
  ];

  meta = with lib; {
    description = "HTTP traffic mocking and testing";
    homepage = "https://github.com/h2non/pook";
    changelog = "https://github.com/h2non/pook/blob/v${version}/History.rst";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
