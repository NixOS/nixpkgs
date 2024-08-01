{
  lib,
  bleak,
  bleak-retry-connector,
  bluetooth-data-tools,
  bluetooth-sensor-state-data,
  buildPythonPackage,
  fetchFromGitHub,
  miauth,
  pythonOlder,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "ninebot-ble";
  version = "0.0.6";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "ownbee";
    repo = "ninebot-ble";
    rev = "refs/tags/${version}";
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

  meta = with lib; {
    description = "Ninebot scooter BLE client";
    mainProgram = "ninebot-ble";
    homepage = "https://github.com/ownbee/ninebot-ble";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
