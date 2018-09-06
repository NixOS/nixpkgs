{ lib, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "hvac";
  version = "0.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "54672a93f75453a7de13c7c10c6d8a51630e2559a8e2a563d8e272e9e188443f";
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
