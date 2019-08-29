{ lib, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "hvac";
  version = "0.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "773775fa827c74299abd96079eeeeb0cefbb23b484195c03cff27d04716539ba";
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
