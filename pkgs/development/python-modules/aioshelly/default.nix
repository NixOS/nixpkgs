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

buildPythonPackage rec {
  pname = "aioshelly";
  version = "13.25.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "aioshelly";
    tag = version;
    hash = "sha256-BZsuvYtP2tuRb3QGN09lwTXadMKqM1TLPKEQU5+qz6w=";
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
    changelog = "https://github.com/home-assistant-libs/aioshelly/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
