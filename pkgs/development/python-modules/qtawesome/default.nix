{ lib, buildPythonPackage, fetchPypi, qtpy, six, pyqt5, pytest }:

buildPythonPackage rec {
  pname = "QtAwesome";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ec02e200231fa68a146a93845890aa0432a7edcba14bf811ff6975cf9acdab5d";
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
