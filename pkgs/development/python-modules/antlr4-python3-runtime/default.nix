{ stdenv, fetchurl, buildPythonPackage, isPy3k }:

buildPythonPackage rec {
  version = "4.7.1";
  name = "antlr4-python3-runtime-${version}";
  disabled = !isPy3k;

  src = fetchurl {
    url = "mirror://pypi/a/antlr4-python3-runtime/${name}.tar.gz";
    sha256 = "1lrzmagawmavyw1n1z0qarvs2jmbnbv0p89dah8g7klj8hnbf9hv";
  };

  meta = {
    description = "Runtime for ANTLR";
    homepage = "http://www.antlr.org/";
    license = stdenv.lib.licenses.bsd3;
  };
}
