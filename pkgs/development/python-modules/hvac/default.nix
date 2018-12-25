{ lib, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "hvac";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4fc3ca6b463200da5186a520ba7f6ce6d2873f9df0139e326665e9ea22514db3";
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
