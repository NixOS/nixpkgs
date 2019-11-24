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
  version = "2.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ce4adb60fe67ebe91f2fc57d5067b4e44df6e233652987be4fb2e549688cf9fe";
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