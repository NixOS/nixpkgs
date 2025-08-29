{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytest-aiohttp,
  pytest-asyncio_0,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiohttp-sse";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiohttp-sse";
    tag = "v${version}";
    hash = "sha256-iCjWuECUQukCtlQPjztEwawqSzd3LvvWRGXnhZem22w=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
  ];

  pythonImportsCheck = [ "aiohttp_sse" ];

  nativeCheckInputs = [
    (pytest-aiohttp.override { pytest-asyncio = pytest-asyncio_0; })
    pytest-asyncio_0
    pytest-cov-stub
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    changelog = "https://github.com/aio-libs/aiohttp-sse/blob/${src.tag}/CHANGES.rst";
    description = "Server-sent events support for aiohttp";
    homepage = "https://github.com/aio-libs/aiohttp-sse";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
