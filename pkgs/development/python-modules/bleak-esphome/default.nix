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

buildPythonPackage rec {
  pname = "bleak-esphome";
  version = "3.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bluetooth-devices";
    repo = "bleak-esphome";
    tag = "v${version}";
    hash = "sha256-BFF4SqJxrQ+aaFtrNqS9fNqTV2Q+pOu5FFdYKeHkKj8=";
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

  meta = with lib; {
    description = "Bleak backend of ESPHome";
    homepage = "https://github.com/bluetooth-devices/bleak-esphome";
    changelog = "https://github.com/bluetooth-devices/bleak-esphome/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
