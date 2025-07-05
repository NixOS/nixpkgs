{
  lib,
  aiohttp,
  aioresponses,
  bluetooth-data-tools,
  buildPythonPackage,
  fetchFromGitHub,
  habluetooth,
  orjson,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  yarl,
}:

buildPythonPackage rec {
  pname = "aioshelly";
  version = "13.7.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "aioshelly";
    tag = version;
    hash = "sha256-EQyq+l/WhM4mAQrq9D4F3hglk2EkvCrSD6tYbUr0aWw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    bluetooth-data-tools
    habluetooth
    orjson
    yarl
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioshelly" ];

  meta = with lib; {
    description = "Python library to control Shelly";
    homepage = "https://github.com/home-assistant-libs/aioshelly";
    changelog = "https://github.com/home-assistant-libs/aioshelly/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
