{ stdenv, buildPythonPackage, fetchPypi, pytestrunner, pytest }:

buildPythonPackage rec {
  pname = "Cerberus";
  version = "1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a5b39090fde3ec3294c9d7030b8eda935b42222160a66a922e0c8aea34cabfdf";
  };

  checkInputs = [ pytestrunner pytest ];

  meta = with stdenv.lib; {
    homepage = http://python-cerberus.org/;
    description = "Lightweight, extensible schema and data validation tool for Python dictionaries";
    license = licenses.mit;
  };
}
