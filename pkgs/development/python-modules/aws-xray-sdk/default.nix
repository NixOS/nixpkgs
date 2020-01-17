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
  version = "2.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "263a38f3920d9dc625e3acb92e6f6d300f4250b70f538bd009ce6e485676ab74";
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