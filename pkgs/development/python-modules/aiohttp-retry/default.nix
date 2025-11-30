{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-aiohttp,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiohttp-retry";
  version = "2.9.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "inyutin";
    repo = "aiohttp_retry";
    tag = "v${version}";
    hash = "sha256-8S4gjeN8ktdDNd8GUsejaZdCaG/VXYPo0RJpwrrttGQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiohttp_retry" ];

  pytestFlags = [ "--asyncio-mode=auto" ];

  meta = with lib; {
    description = "Retry client for aiohttp";
    homepage = "https://github.com/inyutin/aiohttp_retry";
    changelog = "https://github.com/inyutin/aiohttp_retry/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
