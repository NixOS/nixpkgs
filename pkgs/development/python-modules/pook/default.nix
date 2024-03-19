{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, furl
, hatchling
, jsonschema
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, requests
, xmltodict
}:

buildPythonPackage rec {
  pname = "pook";
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "h2non";
    repo = "pook";
    rev = "refs/tags/v${version}";
    hash = "sha256-0sS2QJcshMuxxCGlrcVHeIQnVMZbBoJfLsRIxpvl7pM=";
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
    pytestCheckHook
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
