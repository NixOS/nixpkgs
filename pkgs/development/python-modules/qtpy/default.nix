{ stdenv, buildPythonPackage, fetchPypi, pyside, pytest }:

buildPythonPackage rec {
  pname = "QtPy";
  version = "1.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17pdn4d77gjjrsq7m1i6dz9px0dfi6wgaqz2v3sa3crl15spawp9";
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
