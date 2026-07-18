{
  lib,
  aio-georss-client,
  aiointercept,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  python-dateutil,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aio-georss-gdacs";
  version = "2026.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-georss-gdacs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2Ot7w2TU7nwnHePFCaCr7LZNbKbOLxADnHoieFUGg40=";
  };

  __darwinAllowLocalNetworking = true;

  build-system = [ setuptools ];

  dependencies = [
    aio-georss-client
    python-dateutil
  ];

  nativeCheckInputs = [
    aiointercept
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aio_georss_gdacs" ];

  meta = {
    description = "Python library for accessing GeoRSS feeds";
    homepage = "https://github.com/exxamalte/python-aio-georss-gdacs";
    changelog = "https://github.com/exxamalte/python-aio-georss-gdacs/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
