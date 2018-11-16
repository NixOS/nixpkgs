{ stdenv, buildPythonPackage, fetchPypi, qtpy, six, pyside }:

buildPythonPackage rec {
  pname = "QtAwesome";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15n6ywfkx5vap0bvayh6n572kw5fkqnzpq5ga4a4d7v52nnxbba1";
  };

  propagatedBuildInputs = [ qtpy six pyside ];

  meta = with stdenv.lib; {
    description = "Iconic fonts in PyQt and PySide applications";
    homepage = https://github.com/spyder-ide/qtawesome;
    license = licenses.mit;
  };
}
