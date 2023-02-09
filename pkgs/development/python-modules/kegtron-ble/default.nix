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
  pname = "kegtron-ble";
  version = "0.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-O5I5shW8nL2RAQptS2Bp/GI/4L6o0xXXmwYvRq0MM8o=";
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
      --replace " --cov=kegtron_ble --cov-report=term-missing:skip-covered" ""
  '';

  pythonImportsCheck = [
    "kegtron_ble"
  ];

  meta = with lib; {
    description = "Library for Kegtron BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/kegtron-ble";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
