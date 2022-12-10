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
  pname = "bluemaestro-ble";
  version = "0.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-lJYbbF6b1CazD/aVTNoZvyfH/XQf5jWBsddDdrP+FKA=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    bluetooth-data-tools
    bluetooth-sensor-state-data
    sensor-state-data
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=bluemaestro_ble --cov-report=term-missing:skip-covered" ""
  '';

  pythonImportsCheck = [
    "bluemaestro_ble"
  ];

  meta = with lib; {
    description = "Library for bluemaestro BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/bluemaestro-ble";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
