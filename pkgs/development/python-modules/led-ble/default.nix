{ lib
, async-timeout
, bleak
, bleak-retry-connector
, buildPythonPackage
, fetchFromGitHub
, flux-led
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "led-ble";
  version = "0.10.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-GyVj9g4tqPaR5Gd8N76TtkldaAATnEBsSs/F+2iQqGM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=led_ble --cov-report=term-missing:skip-covered" ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    async-timeout
    bleak
    bleak-retry-connector
    flux-led
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "led_ble"
  ];

  meta = with lib; {
    description = "Library for LED BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/led-ble";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
