{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  # build-system
  setuptools-scm,
  # dependencies
  pyserial,
}:

buildPythonPackage rec {
  pname = "adafruit-board-toolkit";
  version = "1.1.1";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-k8TwmztGnCqS6F5ZrXSBnefZzc2kvuUqYxGAejRAdsI=";
  };

  # Project has not published tests yet
  doCheck = false;

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    pyserial
  ];
  pythonImportsCheck = [ "adafruit_board_toolkit" ];
  meta = {
    description = "CircuitPython board identification and information";
    homepage = "https://github.com/adafruit/Adafruit_Board_Toolkit";
    changelog = "https://github.com/adafruit/Adafruit_Board_Toolkit/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ talhaHavadar ];
  };
}
