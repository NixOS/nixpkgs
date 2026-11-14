{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  spidev,
  rpi-lgpio,
}:

buildPythonPackage (finalAttrs: {
  pname = "LoRaRF";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chandrawi";
    repo = "LoRaRF-Python";
    rev = finalAttrs.version;
    hash = "sha256-BdUpq0vwrhmg79sjTOEHen8hQRpcw34WlblXrlK3RWs=";
  };

  preBuild = ''
    rm -rf dist/
    substituteInPlace setup.cfg --replace-fail RPi.GPIO rpi-lgpio
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    spidev
    rpi-lgpio
  ];

  # Tests do a platform check which requires running on a Raspberry Pi
  doCheck = false;

  meta = {
    description = "Python library used for basic transmitting and receiving data using LoRa modem";
    homepage = "https://github.com/chandrawi/LoRaRF-Python";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      robertjakub
    ];
  };
})
