{ lib, buildPythonPackage, fetchPypi, qtpy, six, pyqt5, pytest }:

buildPythonPackage rec {
  pname = "QtAwesome";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9EDcqz1PyKz6WHXIxWXXvVjlN5Z6cDZ5SExcVnvj8SA=";
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
