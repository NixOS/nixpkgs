{ lib
, bluetooth-data-tools
, bluetooth-sensor-state-data
, buildPythonPackage
, cryptography
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
, pytz
, sensor-state-data
}:

buildPythonPackage rec {
  pname = "bthome-ble";
  version = "3.7.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "bthome-ble";
    rev = "refs/tags/v${version}";
    hash = "sha256-ALLeJdEYCFtGZb7dO7xW8Mv331kmQpl0e/CUt9erjHc=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    bluetooth-data-tools
    bluetooth-sensor-state-data
    cryptography
    sensor-state-data
    pytz
  ];

  nativeCheckInputs = [
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
    changelog = "https://github.com/bluetooth-devices/bthome-ble/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
