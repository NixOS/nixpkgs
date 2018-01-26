{ lib
, buildPythonPackage
, fetchPypi
, jsonpickle
, wrapt
, requests
}:

buildPythonPackage rec {
  pname = "aws-xray-sdk";
  version = "0.95";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e7ba8dd08fd2939376c21423376206bff01d0deaea7d7721c6b35921fed1943";
  };

  propagatedBuildInputs = [
    jsonpickle wrapt requests
  ];

  meta = {
    description = "AWS X-Ray SDK for the Python programming language";
    license = lib.licenses.asl20;
    homepage = https://github.com/aws/aws-xray-sdk-python;
  };

  doCheck = false;
}