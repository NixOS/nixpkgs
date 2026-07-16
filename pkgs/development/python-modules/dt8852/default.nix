{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  pyserial,
}:

buildPythonPackage rec {
  pname = "dt8852";
  version = "1.1.0";
  pyproject = true;

  # Not using Codeberg because there's no tagged release there.
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3WiHJQnlP39CGzxu/sZ1jWcP40tyr2G62H4yYuwS0wA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyserial
  ];

  # No tests available on PyPi and Codeberg source.
  doCheck = false;

  pythonImportsCheck = [ "dt8852" ];

  meta = {
    description = "Dt8852 is a cross-platform Python package and module for reading and controlling CEM DT-8852 and equivalent Sound Level Meter and Data Logger devices";
    homepage = "https://codeberg.org/randysimons/dt8852";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "dt8852";
  };
}
