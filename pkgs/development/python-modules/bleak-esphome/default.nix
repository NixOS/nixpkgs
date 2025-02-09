{
  lib,
  aioesphomeapi,
  bleak,
  bluetooth-data-tools,
  buildPythonPackage,
  fetchFromGitHub,
  habluetooth,
  lru-dict,
  poetry-core,
  pytest-asyncio,
  pytest-codspeed,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "bleak-esphome";
  version = "2.7.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "bluetooth-devices";
    repo = "bleak-esphome";
    tag = "v${version}";
    hash = "sha256-AZkSWBMyTl2NgqmhVG4sE/N1AQGd6x4CZVYMgRKxlOQ=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aioesphomeapi
    bleak
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

  pythonImportsCheck = [ "bleak_esphome" ];

  meta = with lib; {
    description = "Bleak backend of ESPHome";
    homepage = "https://github.com/bluetooth-devices/bleak-esphome";
    changelog = "https://github.com/bluetooth-devices/bleak-esphome/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
