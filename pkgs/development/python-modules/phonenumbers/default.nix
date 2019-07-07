{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "phonenumbers";
  version = "8.10.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "708c19860afb05085d5fe91b52fcbce9e1be3c020fe8c9b6f6d028879f5a7d5e";
  };

  meta = {
    description = "Python version of Google's common library for parsing, formatting, storing and validating international phone numbers";
    homepage    = https://github.com/daviddrysdale/python-phonenumbers;
    license     = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ fadenb ];
  };
}
