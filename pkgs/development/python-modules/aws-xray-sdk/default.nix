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
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8ec3c6c82e76c03799ec209ed59642d78f62218db6a430f7e2d20491cac3c5ef";
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