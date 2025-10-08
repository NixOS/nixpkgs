{
  lib,
  buildPythonPackage,
  falcon,
  fetchFromGitHub,
  furl,
  hatchling,
  jsonschema,
  pytest-asyncio,
  pytest-httpbin,
  pytest-pook,
  pytestCheckHook,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "pook";
  version = "2.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "h2non";
    repo = "pook";
    tag = "v${version}";
    hash = "sha256-z0QaMdsX2xLXICgQwnlUD2KsgCn0jB4wO83+6O4B3D8=";
  };

  build-system = [ hatchling ];

  dependencies = [
    furl
    jsonschema
    xmltodict
  ];

  nativeCheckInputs = [
    falcon
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
    changelog = "https://github.com/h2non/pook/blob/v${src.tag}/History.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
