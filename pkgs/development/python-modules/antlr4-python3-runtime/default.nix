{ stdenv, fetchPypi, buildPythonPackage, isPy3k }:

buildPythonPackage rec {
  pname = "antlr4-python3-runtime";
  version = "4.7.1";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lrzmagawmavyw1n1z0qarvs2jmbnbv0p89dah8g7klj8hnbf9hv";
  };

  meta = {
    description = "Runtime for ANTLR";
    homepage = http://www.antlr.org/;
    license = stdenv.lib.licenses.bsd3;
  };
}
