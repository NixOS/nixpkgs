{ stdenv, buildPythonPackage, fetchPypi, qtpy, six, pyside }:

buildPythonPackage rec {
  pname = "QtAwesome";
  version = "0.5.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f6dvqmalzi4q4rrpl1xlrxanibam1nifzsgqb5z4jr4ap7kiyp3";
  };

  propagatedBuildInputs = [ qtpy six pyside ];

  meta = with stdenv.lib; {
    description = "Iconic fonts in PyQt and PySide applications";
    homepage = https://github.com/spyder-ide/qtawesome;
    license = licenses.mit;
    platforms = platforms.linux; # fails on Darwin
  };
}
