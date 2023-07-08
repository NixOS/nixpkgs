{ lib
, buildPythonPackage
, fetchFromGitHub
, home-assistant-bluetooth
, poetry-core
, pytestCheckHook
, pythonOlder
, sensor-state-data
}:

buildPythonPackage rec {
  pname = "bluetooth-sensor-state-data";
  version = "1.6.2";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-NC0l3wbQKz4MVM0kHbXBAUol74ir7V/JQgeYCVuyRs4=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    home-assistant-bluetooth
    sensor-state-data
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=bluetooth_sensor_state_data --cov-report=term-missing:skip-covered" ""
  '';

  pythonImportsCheck = [
    "bluetooth_sensor_state_data"
  ];

  meta = with lib; {
    description = "Models for storing and converting Bluetooth Sensor State Data";
    homepage = "https://github.com/bluetooth-devices/bluetooth-sensor-state-data";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
