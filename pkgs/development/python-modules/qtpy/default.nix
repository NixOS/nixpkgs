{ stdenv, buildPythonPackage, fetchPypi, pyside, pytest }:

buildPythonPackage rec {
  pname = "QtPy";
  version = "1.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kdbr8kwryjskhs6mp11jj02h4jdxvlzbzdn1chw30kcb280ysac";
  };

  # no concrete propagatedBuildInputs as multiple backends are supposed
  checkInputs = [ pyside pytest ];

  doCheck = false; # require X
  checkPhase = ''
    py.test qtpy/tests
  '';

  meta = with stdenv.lib; {
    description = "Abstraction layer for PyQt5/PyQt4/PySide2/PySide";
    homepage = https://github.com/spyder-ide/qtpy;
    license = licenses.mit;
  };
}
