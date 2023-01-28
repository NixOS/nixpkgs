{ lib
, bluetooth-data-tools
, bluetooth-sensor-state-data
, buildPythonPackage
, fetchFromGitHub
, home-assistant-bluetooth
, poetry-core
, pytestCheckHook
, pythonOlder
, sensor-state-data
}:

buildPythonPackage rec {
  pname = "inkbird-ble";
  version = "0.5.5";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KUBOjeFM4h2Qt9eT0mQKPFYJJ8OWdbYy9+AiHsJWNyU=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    bluetooth-data-tools
    bluetooth-sensor-state-data
    home-assistant-bluetooth
    sensor-state-data
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=inkbird_ble --cov-report=term-missing:skip-covered" ""
  '';

  pythonImportsCheck = [
    "inkbird_ble"
  ];

  meta = with lib; {
    description = "Library for Inkbird BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/inkbird-ble";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
