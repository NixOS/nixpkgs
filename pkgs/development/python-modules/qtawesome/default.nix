{ stdenv, buildPythonPackage, fetchPypi, qtpy, six, pyside }:

buildPythonPackage rec {
  pname = "QtAwesome";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f415688877b65822d65cb2d9e9e198b37992f4e0ce7778439d14fbea6b4fb4ac";
  };

  propagatedBuildInputs = [ qtpy six pyside ];

  meta = with stdenv.lib; {
    description = "Iconic fonts in PyQt and PySide applications";
    homepage = https://github.com/spyder-ide/qtawesome;
    license = licenses.mit;
  };
}
