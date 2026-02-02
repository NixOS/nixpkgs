{
  lib,
  aioesphomeapi,
  bleak,
  bleak-retry-connector,
  bluetooth-data-tools,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  habluetooth,
  lru-dict,
  poetry-core,
  pytest-asyncio,
  pytest-codspeed,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "bleak-esphome";
  version = "3.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bluetooth-devices";
    repo = "bleak-esphome";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XZ/JjrHJ8Zd1t2Ahi0Jc7S/bkXMIBHfDTVanoGemtI0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=75.8.2" setuptools
  '';

  build-system = [
    cython
    poetry-core
    setuptools
  ];

  dependencies = [
    aioesphomeapi
    bleak
    bleak-retry-connector
    bluetooth-data-tools
    habluetooth
    lru-dict
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-codspeed
    pytest-cov-stub
    pytestCheckHook
  ];

  disabledTests = [
    # bleak_client.services.get_characteristic returns None
    "test_client_get_services_and_read_write"
    "test_bleak_client_get_services_and_read_write"
    "test_bleak_client_cached_get_services_and_read_write"
  ];

  pythonImportsCheck = [ "bleak_esphome" ];

  meta = {
    description = "Bleak backend of ESPHome";
    homepage = "https://github.com/bluetooth-devices/bleak-esphome";
    changelog = "https://github.com/bluetooth-devices/bleak-esphome/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
