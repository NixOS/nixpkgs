{ lib
, buildPythonPackage
, fetchPypi
, jsonpickle
, wrapt
, requests
, future
}:

buildPythonPackage rec {
  pname = "aws-xray-sdk";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13470b95a2f55036a5d7b6642250d8f3a519a6c454cd91f55778b1bb4bf5b89d";
  };

  propagatedBuildInputs = [
    jsonpickle wrapt requests future
  ];

  meta = {
    description = "AWS X-Ray SDK for the Python programming language";
    license = lib.licenses.asl20;
    homepage = https://github.com/aws/aws-xray-sdk-python;
  };

  doCheck = false;
}