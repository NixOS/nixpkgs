{
  lib,
  aiohttp,
  aioresponses,
  bleak-retry-connector,
  bluetooth-data-tools,
  buildPythonPackage,
  fetchFromGitHub,
  habluetooth,
  orjson,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  yarl,
  zeroconf,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioshelly";
  version = "13.26.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "aioshelly";
    tag = finalAttrs.version;
    hash = "sha256-LNMFFi3afbDFezr32zr85lNX1TIdo8BF04yDfc2AIA0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    bleak-retry-connector
    bluetooth-data-tools
    habluetooth
    orjson
    yarl
    zeroconf
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioshelly" ];

  meta = {
    description = "Python library to control Shelly";
    homepage = "https://github.com/home-assistant-libs/aioshelly";
    changelog = "https://github.com/home-assistant-libs/aioshelly/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
