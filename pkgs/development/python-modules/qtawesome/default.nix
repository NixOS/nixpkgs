{ stdenv, buildPythonPackage, fetchPypi, qtpy, six, pyqt5, pytest }:

buildPythonPackage rec {
  pname = "QtAwesome";
  version = "0.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1w4im0hzx497binyx6a6awbyszk1bsz34prm4j72gl5kszkiq7yq";
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
