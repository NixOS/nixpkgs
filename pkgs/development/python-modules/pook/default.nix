{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  furl,
  hatchling,
  jsonschema,
  pytest-asyncio,
  pytest-httpbin,
  pytest-pook,
  pytestCheckHook,
  pythonOlder,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "pook";
  version = "2.1.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "h2non";
    repo = "pook";
    tag = "v${version}";
    hash = "sha256-DDHaKsye28gxyorILulrLRBy/B9zV673jeVZ85uPZAo=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    furl
    jsonschema
    xmltodict
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpbin
    pytest-pook
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pook" ];

  disabledTests = [
    # furl compat issue
    "test_headers_not_matching"
  ];

  disabledTestPaths = [
    # Don't test integrations
    "tests/integration/"
    # Tests require network access
    "tests/unit/interceptors/"
  ];

  # Tests use sockets
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "HTTP traffic mocking and testing";
    homepage = "https://github.com/h2non/pook";
    changelog = "https://github.com/h2non/pook/blob/v${version}/History.rst";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
