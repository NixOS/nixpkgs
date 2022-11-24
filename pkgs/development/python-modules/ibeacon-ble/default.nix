{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, home-assistant-bluetooth
, mac-vendor-lookup
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ibeacon-ble";
  version = "1.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-iYgGflM0IpSIMNgPpJAFAl9FYoMfRinM3sP6VRcBSMc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=ibeacon_ble --cov-report=term-missing:skip-covered" ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    home-assistant-bluetooth
    mac-vendor-lookup
  ];

  checkInputs = [
    pytestCheckHook
  ];

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
