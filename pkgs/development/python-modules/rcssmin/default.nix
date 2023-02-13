{ lib, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "rcssmin";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-T5QAtDZtKfX1RG9Y54VJr6gzjmpZdAxzEV6fasQT3GQ=";
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
