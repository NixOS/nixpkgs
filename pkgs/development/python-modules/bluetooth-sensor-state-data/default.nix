{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  home-assistant-bluetooth,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  sensor-state-data,
}:

buildPythonPackage rec {
  pname = "bluetooth-sensor-state-data";
  version = "1.7.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "bluetooth-sensor-state-data";
    rev = "refs/tags/v${version}";
    hash = "sha256-Gsg6Gbb+nvrKr7vn9zUuPTPtSjqFJyMk7oLt7LUUn5A=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail " --cov=bluetooth_sensor_state_data --cov-report=term-missing:skip-covered" ""
  '';

  build-system = [ poetry-core ];

  dependencies = [
    home-assistant-bluetooth
    sensor-state-data
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bluetooth_sensor_state_data" ];

  meta = with lib; {
    description = "Models for storing and converting Bluetooth Sensor State Data";
    homepage = "https://github.com/bluetooth-devices/bluetooth-sensor-state-data";
    changelog = "https://github.com/Bluetooth-Devices/bluetooth-sensor-state-data/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
