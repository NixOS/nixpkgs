{ stdenv, buildPythonPackage, fetchPypi, qtpy, six, pyqt5, pytest }:

buildPythonPackage rec {
  pname = "QtAwesome";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d612a313e531966d17f5a8fb7604faba961cf7ce3c77a9168c6f60e60140b767";
  };

  propagatedBuildInputs = [ qtpy six ];

  checkInputs = [ pyqt5 pytest ];

  checkPhase = ''
    py.test
  '';

  # Requires https://github.com/boylea/qtbot
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Iconic fonts in PyQt and PySide applications";
    homepage = "https://github.com/spyder-ide/qtawesome";
    license = licenses.mit;
    platforms = platforms.linux; # fails on Darwin
  };
}
