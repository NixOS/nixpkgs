{ lib, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "hvac";
  version = "0.9.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8b98be5868132a591ae5a3ca4b415231d4eac22d3fd77dbd69c3b1081d9ea26d";
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
