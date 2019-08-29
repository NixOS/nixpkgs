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
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bb74e1cc2388bd29c45e2e3eb31d0416d0f53d83baafca7b72ca9c945a2e249a";
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