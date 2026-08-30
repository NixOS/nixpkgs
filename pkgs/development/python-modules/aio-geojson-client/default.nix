{
  lib,
  aiohttp,
  aiointercept,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  geojson,
  haversine,
  mock,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aio-geojson-client";
  version = "2026.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-geojson-client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gC6z3If8OJKDXqpBsWFMy5rYpeqZ2wjljw/dksD0XIU=";
  };

  pythonRelaxDeps = [ "geojson" ];

  __darwinAllowLocalNetworking = true;

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    geojson
    haversine
  ];

  nativeCheckInputs = [
    aioresponses
    aiointercept
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aio_geojson_client" ];

  meta = {
    description = "Python module for accessing GeoJSON feeds";
    homepage = "https://github.com/exxamalte/python-aio-geojson-client";
    changelog = "https://github.com/exxamalte/python-aio-geojson-client/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
