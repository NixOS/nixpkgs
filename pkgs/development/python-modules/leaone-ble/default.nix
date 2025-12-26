{
  lib,
  bluetooth-data-tools,
  bluetooth-sensor-state-data,
  buildPythonPackage,
  fetchFromGitHub,
  home-assistant-bluetooth,
  poetry-core,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  sensor-state-data,
}:

buildPythonPackage rec {
  pname = "leaone-ble";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "bluetooth-devices";
    repo = "leaone-ble";
    tag = "v${version}";
    hash = "sha256-WdsAqXv3U2E5x6Io4t3NNcioV6kwREDATe4hpojzUBo=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    bluetooth-data-tools
    bluetooth-sensor-state-data
    home-assistant-bluetooth
    sensor-state-data
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "leaone_ble" ];

  meta = {
    description = "Bluetooth parser for LeaOne devices";
    homepage = "https://github.com/bluetooth-devices/leaone-ble";
    changelog = "https://github.com/bluetooth-devices/leaone-ble/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
