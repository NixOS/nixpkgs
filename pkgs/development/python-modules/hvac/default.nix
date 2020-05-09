{ lib, buildPythonPackage, fetchPypi, requests, six }:

buildPythonPackage rec {
  pname = "hvac";
  version = "0.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fcd2psvkfsqy45iygm59rzhb7qkbgv3c1dk3x3jvhy6a1ls4kkq";
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
