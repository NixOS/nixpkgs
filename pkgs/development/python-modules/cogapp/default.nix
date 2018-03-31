{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "cogapp";
  version = "2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gzmzbsk54r1qa6wd0yg4zzdxvn2f19ciprr2acldxaknzrpllnn";
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
