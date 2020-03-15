{ lib, buildPythonPackage, fetchPypi, requests, six }:

buildPythonPackage rec {
  pname = "hvac";
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0s0705lk3i1srsjxqhqv9sc2m54fj8lbflxz9gyxf4igxaa6vj1f";
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
