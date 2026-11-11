{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytest-aiohttp,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiohttp-sse";
  version = "3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiohttp-sse";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5Q5k2R0kE1U8IvT9sidezpUYKSjRwSzzMJA4EDMIWfo=";
  };

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
    changelog = "https://github.com/aio-libs/aiohttp-sse/blob/${finalAttrs.src.tag}/CHANGES.rst";
    description = "Server-sent events support for aiohttp";
    homepage = "https://github.com/aio-libs/aiohttp-sse";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
