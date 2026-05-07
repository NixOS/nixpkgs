{
  lib,
  bleak,
  bleak-retry-connector,
  bluetooth-data-tools,
  bluetooth-sensor-state-data,
  buildPythonPackage,
  fetchFromGitHub,
  miauth,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "ninebot-ble";
  version = "0.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ownbee";
    repo = "ninebot-ble";
    tag = version;
    hash = "sha256-gA3VTs45vVpO0Iy8MbvvDf9j99vsFzrkADaJEslx6y0=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    bleak
    bleak-retry-connector
    bluetooth-data-tools
    bluetooth-sensor-state-data
    miauth
  ];

  # Module has no test
  doCheck = false;

  pythonImportsCheck = [ "ninebot_ble" ];

  meta = {
    description = "Ninebot scooter BLE client";
    mainProgram = "ninebot-ble";
    homepage = "https://github.com/ownbee/ninebot-ble";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
