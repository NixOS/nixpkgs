{ lib, buildPythonPackage, fetchPypi, requests, six }:

buildPythonPackage rec {
  pname = "hvac";
  version = "0.10.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "391b558a465d1919a2862926ab9a7c6bef1f2ac2c46daf8dd5115080c42978e4";
  };

  propagatedBuildInputs = [ requests six ];

  # Requires running a Vault server
  doCheck = false;

  meta = with lib; {
    description = "HashiCorp Vault API client";
    homepage = "https://github.com/ianunruh/hvac";
    license = licenses.asl20;
  };
}
