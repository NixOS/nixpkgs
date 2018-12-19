{ lib
, buildPythonPackage
, fetchPypi
, jsonpickle
, wrapt
, requests
, future
, botocore
}:

buildPythonPackage rec {
  pname = "aws-xray-sdk";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fc5537268cc8041f74e14077c4b4b4cef0f3de25ecef793ace63cedf87fe4a2a";
  };

  propagatedBuildInputs = [
    jsonpickle wrapt requests future botocore
  ];

  meta = {
    description = "AWS X-Ray SDK for the Python programming language";
    license = lib.licenses.asl20;
    homepage = https://github.com/aws/aws-xray-sdk-python;
  };

  doCheck = false;
}