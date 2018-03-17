{ lib, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "hvac";
  version = "0.2.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qxa4g1ij1bj27mbp8l54lcr7d5krkb2rayisc6shkpf2b51ip4c";
  };

  propagatedBuildInputs = [ requests ];

  meta = with lib; {
    description = "HashiCorp Vault API client";
    homepage = https://github.com/ianunruh/hvac;
    license = licenses.asl20;
  };
}
