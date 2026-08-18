{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-aiohttp,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiohttp-retry";
  version = "2.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "inyutin";
    repo = "aiohttp_retry";
    tag = "v${version}";
    hash = "sha256-8S4gjeN8ktdDNd8GUsejaZdCaG/VXYPo0RJpwrrttGQ=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'version="2.9.0"' 'version="${version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiohttp_retry" ];

  pytestFlags = [ "--asyncio-mode=auto" ];

  meta = {
    description = "Retry client for aiohttp";
    homepage = "https://github.com/inyutin/aiohttp_retry";
    changelog = "https://github.com/inyutin/aiohttp_retry/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
