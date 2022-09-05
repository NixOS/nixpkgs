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
  version = "0.7.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-B7ywK0xkSoO9Cg2VTxxzebnnHXSCD8jf2Ylk4Fw4VY4=";
  };

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

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=led_ble --cov-report=term-missing:skip-covered" ""
  '';

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
