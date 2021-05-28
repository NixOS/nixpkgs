{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "phonenumbers";
  version = "8.12.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d6e108352e7113c55cf0d92f8aede876a379580e46a3b9c2e779dc3601f11863";
  };

  meta = {
    description = "Python version of Google's common library for parsing, formatting, storing and validating international phone numbers";
    homepage    = "https://github.com/daviddrysdale/python-phonenumbers";
    license     = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ fadenb ];
  };
}
