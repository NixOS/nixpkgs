{ lib, buildPythonPackage, fetchPypi, pyside, pytest }:

buildPythonPackage rec {
  pname = "QtPy";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "777e333df4d711b2ec9743117ab319dadfbd743a5a0eee35923855ca3d35cd9d";
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
