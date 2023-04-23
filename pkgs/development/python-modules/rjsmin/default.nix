{ lib, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "rjsmin";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-H5gr6OARQ4d3qUMHJ5tAE0o5NfwPB5MS7imXJbivVBE=";
  };

  # The package does not ship tests, and the setup machinary confuses
  # tests auto-discovery
  doCheck = false;

  meta = with lib; {
    homepage = "http://opensource.perlig.de/rjsmin/";
    license = licenses.asl20;
    description = "Javascript minifier written in python";
  };
}
