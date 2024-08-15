{
  buildPythonPackage,
  fetchPypi,
  setuptools,
  lib,
  pythonOlder,
}:
buildPythonPackage rec {
  pname = "pwinput";
  version = "1.0.3";

  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "pwinput";
    hash = "sha256-yhqL0G4ohy11Hb1BMthjcSfCW0COo6NJN3MUpUkUJvM=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pwinput" ];

  # Requires graphical environment to use pyautogui
  doCheck = false;

  meta = {
    description = "Python module that masks password input";
    homepage = "https://github.com/asweigart/pwinput";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bwkam ];
  };
}
