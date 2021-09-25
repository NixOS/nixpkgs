{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "cogapp";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c43e374ee5ca2a35fbc68556f598bd8578eabe8a890487980bba56945b5ce9c6";
  };

  # there are no tests
  doCheck = false;

  meta = with lib; {
    description = "A code generator for executing Python snippets in source files";
    homepage = "http://nedbatchelder.com/code/cog";
    license = licenses.mit;
    maintainers = with maintainers; [ lovek323 ];
  };
}
