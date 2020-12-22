{ lib, buildPythonPackage, fetchPypi, requests, six }:

buildPythonPackage rec {
  pname = "hvac";
  version = "0.10.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b0561dbdfecc6a6d7b0cc226d75a800ae9bbc93313a6ad526a1adc97be51eada";
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
