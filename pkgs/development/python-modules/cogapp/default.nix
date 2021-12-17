{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "cogapp";
  version = "3.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09a6e82a55af45f5e946d7002ed997869abf6f57d28fdc79f128132b5da18bf8";
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
