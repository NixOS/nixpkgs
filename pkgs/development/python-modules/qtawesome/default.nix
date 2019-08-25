{ stdenv, buildPythonPackage, fetchPypi, qtpy, six, pyqt5, pytest }:

buildPythonPackage rec {
  pname = "QtAwesome";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05qypwlzjkw31x7qgn01d4kcf40mbymg5c9h3i7cx2r8sw29akjy";
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
    homepage = https://github.com/spyder-ide/qtawesome;
    license = licenses.mit;
    platforms = platforms.linux; # fails on Darwin
  };
}
