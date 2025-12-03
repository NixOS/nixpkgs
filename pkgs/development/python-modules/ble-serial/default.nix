{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  bleak,
  coloredlogs,
  pyserial,
  bless,
}:

buildPythonPackage rec {
  pname = "ble-serial";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jakeler";
    repo = "ble-serial";
    tag = "v${version}";
    hash = "sha256-lbqu6VeE8XEIUvUILqKsTA+0/lxTr8GTbUBkSae/ruE=";
    fetchSubmodules = true;
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    bleak
    coloredlogs
    pyserial
  ];

  optional-dependencies = {
    server = [
      bless
    ];
  };

  # Requires real hardware to test
  # https://github.com/Jakeler/ble-serial/blob/3f1a619208a0eb372a0993aadc086c4842946f21/tests/test.py
  doCheck = false;

  pythonImportsCheck = [
    "ble_serial.bluetooth.ble_client"
    "ble_serial.scan"
  ];

  meta = {
    description = "\"RFCOMM for BLE\" a Serial UART over Bluetooth low energy (4+) bridge";
    homepage = "https://github.com/Jakeler/ble-serial";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
    platforms = lib.platforms.unix;
  };
}
