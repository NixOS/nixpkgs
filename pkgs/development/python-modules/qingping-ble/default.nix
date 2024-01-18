{ lib
, bluetooth-data-tools
, bluetooth-sensor-state-data
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
, sensor-state-data
}:

buildPythonPackage rec {
  pname = "qingping-ble";
  version = "0.9.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bluetooth-devices";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-h2PVrwesUaJfwJtuNf44bd1MefpSmOm7Q4A/URvd+IY=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    bluetooth-data-tools
    bluetooth-sensor-state-data
    sensor-state-data
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=qingping_ble --cov-report=term-missing:skip-covered" ""
  '';

  pythonImportsCheck = [
    "qingping_ble"
  ];

  meta = with lib; {
    description = "Library for Qingping BLE devices";
    homepage = "https://github.com/bluetooth-devices/qingping-ble";
    changelog = "https://github.com/Bluetooth-Devices/qingping-ble/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
