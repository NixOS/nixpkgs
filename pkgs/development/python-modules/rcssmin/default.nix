{ lib, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "rcssmin";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "27fc400627fd3d328b7fe95af2a01f5d0af6b5af39731af5d071826a1f08e362";
  };

  # The package does not ship tests, and the setup machinary confuses
  # tests auto-discovery
  doCheck = false;

  meta = with lib; {
    homepage = "http://opensource.perlig.de/rcssmin/";
    license = licenses.asl20;
    description = "CSS minifier written in pure python";
  };
}
