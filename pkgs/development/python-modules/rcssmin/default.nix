{ lib, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "rcssmin";
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vHXrdb1tNFwMUf2A/Eh93W+f1AndeGGz/pje6FAY4ek=";
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
