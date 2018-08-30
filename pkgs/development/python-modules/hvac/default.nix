{ lib, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "hvac";
  version = "0.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4bc80744df5f09882b1cc91755b03b7b62b093fc63c8c4abb26fbfb9c9e878dd";
  };

  propagatedBuildInputs = [ requests ];

  # Requires running a Vault server
  doCheck = false;

  meta = with lib; {
    description = "HashiCorp Vault API client";
    homepage = https://github.com/ianunruh/hvac;
    license = licenses.asl20;
  };
}
