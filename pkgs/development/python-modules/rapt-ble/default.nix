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
  pname = "rapt-ble";
  version = "0.1.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "sairon";
    repo = "rapt-ble";
    tag = "v${version}";
    hash = "sha256-ozZwVgTV/xYl1nXLiybcPs6DQKocNdbxTEYDfYyQuvY=";
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

  pythonImportsCheck = [ "rapt_ble" ];

  meta = with lib; {
    description = "Library for RAPT Pill hydrometer BLE devices";
    homepage = "https://github.com/sairon/rapt-ble";
    changelog = "https://github.com/sairon/rapt-ble/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
