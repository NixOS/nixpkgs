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
  version = "2.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "90c2fcc982a770e86d009a4c3d2b5c3e372da91cb8284d982bae458e2c0bb268";
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
