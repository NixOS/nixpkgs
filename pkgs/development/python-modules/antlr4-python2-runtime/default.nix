{ stdenv, fetchPypi, buildPythonPackage, isPy3k }:

buildPythonPackage rec {
  pname = "antlr4-python2-runtime";
  version = "4.7.2";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "04ljic5wnqpizln8q3c78pqrckz6q5nb433if00j1mlyv2yja22q";
  };

  meta = {
    description = "Runtime for ANTLR";
    homepage = "https://www.antlr.org/";
    license = stdenv.lib.licenses.bsd3;
  };
}
