{ stdenv, buildPythonPackage, fetchPypi, qtpy, six, pyqt5, pytest }:

buildPythonPackage rec {
  pname = "QtAwesome";
  version = "0.5.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f6dvqmalzi4q4rrpl1xlrxanibam1nifzsgqb5z4jr4ap7kiyp3";
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
