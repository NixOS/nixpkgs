{ lib, buildPythonPackage, fetchPypi, requests, six }:

buildPythonPackage rec {
  pname = "hvac";
  version = "0.10.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "87dc2a3183c1d4595990203e752b430155d7582a60850dfe0756189a233d4b57";
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
