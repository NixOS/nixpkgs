{ lib, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "rjsmin";
  version = "1.2.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jBvNghFD/s8jJCAStV4TYQhAqDnNRns1jxY1kBDWLa4=";
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
