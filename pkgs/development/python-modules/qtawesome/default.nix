{ lib, buildPythonPackage, fetchPypi, qtpy, six, pyqt5, pytest }:

buildPythonPackage rec {
  pname = "QtAwesome";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d37bbeb69ddc591e5ff036b741bda8d1d92133811f1f5a7150021506f70b8e6e";
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
