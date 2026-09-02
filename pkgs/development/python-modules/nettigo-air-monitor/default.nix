{
  lib,
  aiohttp,
  aiointercept,
  aioresponses,
  aqipy-atmotech,
  buildPythonPackage,
  dacite,
  fetchFromGitHub,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-error-for-skips,
  pytestCheckHook,
  setuptools,
  syrupy,
  tenacity,
}:

buildPythonPackage (finalAttrs: {
  pname = "nettigo-air-monitor";
  version = "5.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = "nettigo-air-monitor";
    tag = finalAttrs.version;
    hash = "sha256-CW3Z9AI0ncS+U14s3MnokPdcag90o/yrCOp+2lfQ3CM=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [
    aiohttp
    aqipy-atmotech
    dacite
    tenacity
  ];

  nativeCheckInputs = [
    aiointercept
    aioresponses
    pytest-asyncio
    pytest-error-for-skips
    pytestCheckHook
    syrupy
  ];

  disabledTests = [
    # stuck in epoll
    "test_retry_fail"
    "test_retry_success"
  ];

  pythonImportsCheck = [ "nettigo_air_monitor" ];

  meta = {
    description = "Python module to get air quality data from Nettigo Air Monitor devices";
    homepage = "https://github.com/bieniu/nettigo-air-monitor";
    changelog = "https://github.com/bieniu/nettigo-air-monitor/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
