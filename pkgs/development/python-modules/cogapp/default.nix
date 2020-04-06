{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "cogapp";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5e5da2bcfc4e4750c66cecb80ea4eaed1ef4fddd3787c989d4f5bfffb1152d6a";
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
