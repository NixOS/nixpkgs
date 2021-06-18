{ lib, buildPythonPackage, fetchPypi, requests, six }:

buildPythonPackage rec {
  pname = "hvac";
  version = "0.10.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c616f29d6642adaabcd408a04469374ed83be12b24501bb337e8f37badfef22";
  };

  propagatedBuildInputs = [ requests six ];

  # Requires running a Vault server
  doCheck = false;

  pythonImportsCheck = [ "hvac" ];

  meta = with lib; {
    description = "HashiCorp Vault API client";
    homepage = "https://github.com/ianunruh/hvac";
    license = licenses.asl20;
  };
}
