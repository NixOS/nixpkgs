{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "cogapp";
  version = "2.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f8cf2288fb5a2087eb4a00d8b347ddc86e9058d4ab26b8c868433eb401adfe1c";
  };

  # there are no tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A code generator for executing Python snippets in source files";
    homepage = http://nedbatchelder.com/code/cog;
    license = licenses.mit;
    maintainers = with maintainers; [ lovek323 ];
  };
}
