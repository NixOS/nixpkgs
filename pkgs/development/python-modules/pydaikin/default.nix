{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  netifaces,
  pytest-asyncio,
  pytestCheckHook,
  urllib3,
  setuptools,
  tenacity,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydaikin";
  version = "2.18.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fredrike";
    repo = "pydaikin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sTcdgbthDAyyWLxPtS344xR8a7UoN+zrfes6FXSo9g4=";
  };

  __darwinAllowLocalNetworking = true;

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    netifaces
    urllib3
    tenacity
  ];

  nativeCheckInputs = [
    aresponses
    freezegun
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # Failed: async def functions are not natively supported.
    "test_power_sensors"
    "test_device_factory"
  ];

  pythonImportsCheck = [ "pydaikin" ];

  meta = {
    description = "Python Daikin HVAC appliances interface";
    homepage = "https://github.com/fredrike/pydaikin";
    changelog = "https://github.com/fredrike/pydaikin/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pydaikin";
  };
})
