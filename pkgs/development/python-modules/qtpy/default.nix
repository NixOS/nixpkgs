{ lib, buildPythonPackage, fetchPypi, pyside, pytest }:

buildPythonPackage rec {
  pname = "QtPy";
  version = "1.11.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d427addd37386a8d786db81864a5536700861d95bf085cb31d1bea855d699557";
  };

  # no concrete propagatedBuildInputs as multiple backends are supposed
  checkInputs = [ pyside pytest ];

  doCheck = false; # require X
  checkPhase = ''
    py.test qtpy/tests
  '';

  meta = with lib; {
    description = "Abstraction layer for PyQt5/PyQt4/PySide2/PySide";
    homepage = "https://github.com/spyder-ide/qtpy";
    license = licenses.mit;
  };
}
