{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  syrupy,
  yarl,
}:

buildPythonPackage rec {
  pname = "aiowaqi";
  version = "3.1.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-waqi";
    tag = "v${version}";
    hash = "sha256-YWTGEOSSkZ0XbZUE3k+Dn9qg8Pmwip9wCp8e/j1D9io=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "aiowaqi" ];

  disabledTests = [
    # Upstream mocking fails
    "test_search"
  ];

  pytestFlags = [ "--snapshot-update" ];

  meta = with lib; {
    description = "Module to interact with the WAQI API";
    homepage = "https://github.com/joostlek/python-waqi";
    changelog = "https://github.com/joostlek/python-waqi/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
