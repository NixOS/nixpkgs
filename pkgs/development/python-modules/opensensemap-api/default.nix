{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "opensensemap-api";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-opensensemap-api";
    tag = finalAttrs.version;
    hash = "sha256-cCvKgB2tdYZw7it8YAtZZgsQrGUQKGNLqWiERKDCMVw=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    async-timeout
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opensensemap_api" ];

  meta = {
    description = "OpenSenseMap API Python client";
    longDescription = ''
      Python Client for interacting with the openSenseMap API. All
      available information from the sensor can be retrieved.
    '';
    homepage = "https://github.com/home-assistant-ecosystem/python-opensensemap-api";
    changelog = "https://github.com/home-assistant-ecosystem/python-opensensemap-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
