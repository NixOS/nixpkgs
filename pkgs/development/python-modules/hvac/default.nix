{ lib, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "hvac";
  version = "0.6.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d7f23883c44458078359142608d0bc6373c4bcec107bdb609c827ee1dda61431";
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
