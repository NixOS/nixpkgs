{ lib
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
  version = "0.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bluetooth-devices";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-AJ5mS5IChbmlyUBpq95malPPh9NnB2p3dzS4fUJAkDI=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    bluetooth-sensor-state-data
    sensor-state-data
  ];

  checkInputs = [
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
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
