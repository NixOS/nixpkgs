{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, importlib-metadata
, jsonpickle
, wrapt
, requests
, future
, botocore
}:

buildPythonPackage rec {
  pname = "aws-xray-sdk";
  version = "2.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-mxSST9BijPkpNgVYZGVTVAA/CxrMPhw//eZAPQeZ3Xo=";
  };

  propagatedBuildInputs = [
    jsonpickle wrapt requests future botocore
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  meta = {
    description = "AWS X-Ray SDK for the Python programming language";
    license = lib.licenses.asl20;
    homepage = "https://github.com/aws/aws-xray-sdk-python";
  };

  doCheck = false;
}
