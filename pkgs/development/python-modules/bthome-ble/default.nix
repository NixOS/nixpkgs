{ lib
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
  version = "0.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kZ+c7eBnC9Oeen56+A1KSCQZJJyoNcN6y6yiBSwClTQ=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
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
