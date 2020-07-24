{ lib, buildPythonPackage, fetchPypi, requests, six }:

buildPythonPackage rec {
  pname = "hvac";
  version = "0.10.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0yhywm8f86pc4f7ivvbwicwhzf0khjqp9jj77pqy6nha6znvpvnh";
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
