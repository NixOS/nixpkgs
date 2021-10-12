{ lib, buildPythonPackage, fetchPypi, pyside, pytest }:

buildPythonPackage rec {
  pname = "QtPy";
  version = "1.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3d20f010caa3b2c04835d6a2f66f8873b041bdaf7a76085c2a0d7890cdd65ea9";
  };

  # no concrete propagatedBuildInputs as multiple backends are supposed
  checkInputs = [ pyside pytest ];

  doCheck = false; # require X
  checkPhase = ''
    py.test qtpy/tests
  '';

  meta = with lib; {
    description = "Abstraction layer for PyQt5/PyQt4/PySide2/PySide";
    homepage = "https://github.com/spyder-ide/qtpy";
    license = licenses.mit;
  };
}
