{ lib, buildPythonPackage, fetchPypi, requests, six }:

buildPythonPackage rec {
  pname = "hvac";
  version = "0.10.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6ee2ba6002f11151472fa873b6637d902fc6045a2193aea08b39ae8147c230ba";
  };

  propagatedBuildInputs = [ requests six ];

  # Requires running a Vault server
  doCheck = false;

  pythonImportsCheck = [ "hvac" ];

  meta = with lib; {
    description = "HashiCorp Vault API client";
    homepage = "https://github.com/ianunruh/hvac";
    license = licenses.asl20;
  };
}
