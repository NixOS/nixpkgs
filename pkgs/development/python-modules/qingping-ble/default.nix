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
  version = "0.6.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bluetooth-devices";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0fa5KocDyy3JL7gohbbBghXwbCzbcjK4pVM+zckboHc=";
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
