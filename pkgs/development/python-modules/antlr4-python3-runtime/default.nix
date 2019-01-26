{ stdenv, fetchPypi, buildPythonPackage, isPy3k }:

buildPythonPackage rec {
  pname = "antlr4-python3-runtime";
  version = "4.7.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "02xm7ccsf51vh4xsnhlg6pvchm1x3ckgv9kwm222w5drizndr30n";
  };

  meta = {
    description = "Runtime for ANTLR";
    homepage = "http://www.antlr.org/";
    license = stdenv.lib.licenses.bsd3;
  };
}
