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
  version = "2.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8dfa785305fc8dc720d8d4c2ec6a58e85e467ddc3a53b1506a2ed8b5801c8fc7";
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
