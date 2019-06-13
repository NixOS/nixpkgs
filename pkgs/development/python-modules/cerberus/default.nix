{ stdenv, buildPythonPackage, fetchPypi, pytestrunner, pytest }:

buildPythonPackage rec {
  pname = "Cerberus";
  version = "1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0afhm8x812shj1fbj9jri6wcrlv0avcfis7619sl140mlhpgpzkz";
  };

  checkInputs = [ pytestrunner pytest ];

  meta = with stdenv.lib; {
    homepage = http://python-cerberus.org/;
    description = "Lightweight, extensible schema and data validation tool for Python dictionaries";
    license = licenses.mit;
  };
}
