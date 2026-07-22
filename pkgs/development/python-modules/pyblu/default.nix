{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  lxml,
  mocket,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyblu";
  version = "2.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LouisChrist";
    repo = "pyblu";
    tag = "v${version}";
    hash = "sha256-uYYiu0V491eHg47Rc9HGEiddONnFqGuPj34Mkfk5Gnk=";
  };

  pythonRelaxDeps = [ "aiohttp" ];

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    lxml
  ];

  pythonImportsCheck = [ "pyblu" ];

  nativeCheckInputs = [
    mocket
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [
    # all tests fail with:
    #  aiohttp.client_exceptions.ClientConnectorDNSError: Cannot connect to host node:11000 ssl:default [Could not contact DNS servers]
    "tests/test_player.py"
  ];

  meta = {
    changelog = "https://github.com/LouisChrist/pyblu/releases/tag/${src.tag}";
    description = "BluOS API client";
    homepage = "https://github.com/LouisChrist/pyblu";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
