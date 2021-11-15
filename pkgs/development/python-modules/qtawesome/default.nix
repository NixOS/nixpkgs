{ lib, buildPythonPackage, fetchPypi, qtpy, six, pyqt5, pytest }:

buildPythonPackage rec {
  pname = "QtAwesome";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3fc6eb9327f96ded8e0d291dad4f7a543394c53bff8f9f4badd7433181581a8b";
  };

  propagatedBuildInputs = [ qtpy six ];

  checkInputs = [ pyqt5 pytest ];

  checkPhase = ''
    py.test
  '';

  # Requires https://github.com/boylea/qtbot
  doCheck = false;

  meta = with lib; {
    description = "Iconic fonts in PyQt and PySide applications";
    homepage = "https://github.com/spyder-ide/qtawesome";
    license = licenses.mit;
    platforms = platforms.linux; # fails on Darwin
  };
}
