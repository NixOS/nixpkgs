{ stdenv, buildPythonPackage, fetchPypi, pytestrunner, pytest }:

buildPythonPackage rec {
  pname = "Cerberus";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0be48fc0dc84f83202a5309c0aa17cd5393e70731a1698a50d118b762fbe6875";
  };

  checkInputs = [ pytestrunner pytest ];

  meta = with stdenv.lib; {
    homepage = http://python-cerberus.org/;
    description = "Lightweight, extensible schema and data validation tool for Python dictionaries";
    license = licenses.mit;
  };
}
