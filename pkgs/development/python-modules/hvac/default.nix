{ lib, buildPythonPackage, fetchPypi, requests, six }:

buildPythonPackage rec {
  pname = "hvac";
  version = "0.9.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1v37jabp859691863mw8j06hqxsy16ndf804z2k5y5b0d167j9by";
  };

  propagatedBuildInputs = [ requests six ];

  # Requires running a Vault server
  doCheck = false;

  meta = with lib; {
    description = "HashiCorp Vault API client";
    homepage = https://github.com/ianunruh/hvac;
    license = licenses.asl20;
  };
}
