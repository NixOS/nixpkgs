{ stdenv, buildPythonPackage, fetchPypi, pyside, pytest }:

buildPythonPackage rec {
  pname = "QtPy";
  version = "1.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13cw8l7zrhbdi03k1wl1pg9xdl4ahdfa7yz8gd0f23sxnm22rdrd";
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
