{ stdenv, buildPythonPackage, fetchPypi, qtpy, six, pyside }:

buildPythonPackage rec {
  pname = "QtAwesome";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b5l9xmymyqlkm1phxyfw3s94ydkk3hykndjbkb24n5nfy46h5gl";
  };

  propagatedBuildInputs = [ qtpy six pyside ];

  meta = with stdenv.lib; {
    description = "Iconic fonts in PyQt and PySide applications";
    homepage = https://github.com/spyder-ide/qtawesome;
    license = licenses.mit;
    platforms = platforms.linux; # fails on Darwin
  };
}
