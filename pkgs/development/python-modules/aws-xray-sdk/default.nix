{ lib
, buildPythonPackage
, fetchFromGitHub
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

  src = fetchFromGitHub {
     owner = "aws";
     repo = "aws-xray-sdk-python";
     rev = "2.8.0";
     sha256 = "1kxhplfhb1asnqk0vr0r3adq0ainwhy5fn0x7xjvihslrj6f77xl";
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
