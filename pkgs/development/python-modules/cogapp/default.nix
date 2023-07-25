{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "cogapp";
  version = "3.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1be95183f70282422d594fa42426be6923070a4bd8335621f6347f3aeee81db0";
  };

  # there are no tests
  doCheck = false;

  meta = with lib; {
    description = "A code generator for executing Python snippets in source files";
    homepage = "https://nedbatchelder.com/code/cog";
    license = licenses.mit;
    maintainers = with maintainers; [ lovek323 ];
  };
}
