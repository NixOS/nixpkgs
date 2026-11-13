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
  sensor-state-data,
}:

buildPythonPackage rec {
  pname = "rapt-ble";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sairon";
    repo = "rapt-ble";
    tag = "v${version}";
    hash = "sha256-3+E/ZDoakUGcSyoNw9N2Z5XBQ5hZUseesaq5Iz9EoK4=";
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

  meta = {
    description = "Library for RAPT Pill hydrometer BLE devices";
    homepage = "https://github.com/sairon/rapt-ble";
    changelog = "https://github.com/sairon/rapt-ble/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
