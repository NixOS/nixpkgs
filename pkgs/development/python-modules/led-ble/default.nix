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
  version = "1.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-XAb/tJPUe/sNvcU7t63inMPBIz+AREioWXBuQa/c9T0=";
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

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "led_ble"
  ];

  meta = with lib; {
    description = "Library for LED BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/led-ble";
    changelog = "https://github.com/Bluetooth-Devices/led-ble/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
