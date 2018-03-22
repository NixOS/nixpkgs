{ stdenv, buildPythonPackage, fetchPypi, qtpy, six, pyside }:

buildPythonPackage rec {
  pname = "QtAwesome";
  version = "0.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12l71wh9fcd79d6c7qfzp029iph6gv4daxpg2ddpzr9lrvcw3yah";
  };

  propagatedBuildInputs = [ qtpy six pyside ];

  meta = with stdenv.lib; {
    description = "Iconic fonts in PyQt and PySide applications";
    homepage = https://github.com/spyder-ide/qtawesome;
    license = licenses.mit;
  };
}
