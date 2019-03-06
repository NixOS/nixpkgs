{ stdenv, buildPythonPackage, fetchPypi, pyside, pytest }:

buildPythonPackage rec {
  pname = "QtPy";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fd5c09655e58bf3a013d2940e71f069732ed67f056d4dcb2b0609a3ecd9b320f";
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
