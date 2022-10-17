{ lib
, buildPythonPackage
, fetchFromGitHub
, home-assistant-bluetooth
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ibeacon-ble";
  version = "0.7.4";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-B+ftS/oNCECjCqB396K5iCl0aeJSBGVXshlvZ1kvEuo=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    home-assistant-bluetooth
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=ibeacon_ble --cov-report=term-missing:skip-covered" ""
  '';

  pythonImportsCheck = [
    "ibeacon_ble"
  ];

  meta = with lib; {
    description = "Library for iBeacon BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/ibeacon-ble";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
