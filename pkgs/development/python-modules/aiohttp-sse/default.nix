{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  lib,
  pytest-aiohttp,
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

  patches = [
    (fetchpatch {
      name = "pytest-asyncio-compat.patch";
      url = "https://github.com/aio-libs/aiohttp-sse/commit/22c8041f5f737f76bdba2f2fded58abacf04c913.patch";
      hash = "sha256-CZjXgDKbm3XmS0tn3MGZMnZ84ZLt4o6v9boAYXYa6A4=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
  ];

  pythonImportsCheck = [ "aiohttp_sse" ];

  nativeCheckInputs = [
    pytest-aiohttp
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
