{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "phonenumbers";
  version = "8.12.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3a8b8f7b60ea00b83ca588b5ca57e48d9a3c223aa42f1a3d5fa88566424216c3";
  };

  meta = {
    description = "Python version of Google's common library for parsing, formatting, storing and validating international phone numbers";
    homepage    = "https://github.com/daviddrysdale/python-phonenumbers";
    license     = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ fadenb ];
  };
}
