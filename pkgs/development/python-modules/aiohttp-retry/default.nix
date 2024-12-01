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
  version = "2.9.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "inyutin";
    repo = "aiohttp_retry";
    rev = "refs/tags/v${version}";
    hash = "sha256-9riIGQDxC+Ee16itSWJWobPkmuy7Mkn2eyTkevIGse8=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiohttp_retry" ];

  pytestFlagsArray = [ "--asyncio-mode=auto" ];

  meta = with lib; {
    description = "Retry client for aiohttp";
    homepage = "https://github.com/inyutin/aiohttp_retry";
    changelog = "https://github.com/inyutin/aiohttp_retry/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
