{
  lib,
  aiohttp,
  aiointercept,
  aioresponses,
  buildPythonPackage,
  dateparser,
  fetchFromGitHub,
  haversine,
  mock,
  pytest-asyncio,
  pytestCheckHook,
  requests,
  setuptools,
  xmltodict,
}:

buildPythonPackage (finalAttrs: {
  pname = "aio-georss-client";
  version = "2026.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-georss-client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HstN/X3fJHJHLtduMyeUCK8epqY6yfXi8LlF75mn8+g=";
  };

  __darwinAllowLocalNetworking = true;

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    haversine
    xmltodict
    requests
    dateparser
  ];

  nativeCheckInputs = [
    aiointercept
    aioresponses
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aio_georss_client" ];

  meta = {
    description = "Python library for accessing GeoRSS feeds";
    homepage = "https://github.com/exxamalte/python-aio-georss-client";
    changelog = "https://github.com/exxamalte/python-aio-georss-client/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
