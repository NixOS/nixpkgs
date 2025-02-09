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
  version = "3.3.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "bthome-ble";
    rev = "refs/tags/v${version}";
    hash = "sha256-dFnEgUmmB9P8bKownMp0NsTWPAeMmdKiaxII3O1gT6A=";
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
