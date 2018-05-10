{ lib, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "hvac";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2c9308334301daee3b5c6d56a032ca2c81eeb97d2777b73d795e201e8d037687";
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
