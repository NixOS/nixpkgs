{ lib, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "rjsmin";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6c529feb6c400984452494c52dd9fdf59185afeacca2afc5174a28ab37751a1b";
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
