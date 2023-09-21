{ lib
, bluetooth-data-tools
, bluetooth-sensor-state-data
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pycryptodomex
, pytestCheckHook
, pythonOlder
, sensor-state-data
}:

buildPythonPackage rec {
  pname = "bthome-ble";
  version = "2.2.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-IaDnQCZJZipiPW6lOLrdxw7QfPx/zlwaizkBxv8I2V8=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    bluetooth-data-tools
    bluetooth-sensor-state-data
    sensor-state-data
    pycryptodomex
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=bthome_ble --cov-report=term-missing:skip-covered" ""
  '';

  pythonImportsCheck = [
    "bthome_ble"
  ];

  meta = with lib; {
    description = "Library for BThome BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/bthome-ble";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
