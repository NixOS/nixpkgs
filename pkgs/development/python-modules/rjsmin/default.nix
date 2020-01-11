{ stdenv, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "rjsmin";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cmc72rlkvzz8fl89bc83czkx0pcvhzj7yn7m29r8pgnf5fcfpdi";
  };

  # The package does not ship tests, and the setup machinary confuses
  # tests auto-discovery
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://opensource.perlig.de/rjsmin/;
    license = licenses.asl20;
    description = "Javascript minifier written in python";
  };
}
