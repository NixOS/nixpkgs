{ stdenv, buildPythonPackage, fetchPypi, pyside, pytest }:

buildPythonPackage rec {
  pname = "QtPy";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8e78e7ce28015c1041be68b90f43048c9815e8c89d3362f8073feecdc70eafba";
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
