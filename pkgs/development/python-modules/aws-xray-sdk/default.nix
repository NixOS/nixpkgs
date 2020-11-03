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
  version = "2.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "abf5b90f740e1f402e23414c9670e59cb9772e235e271fef2bce62b9100cbc77";
  };

  requiredPythonModules = [
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
