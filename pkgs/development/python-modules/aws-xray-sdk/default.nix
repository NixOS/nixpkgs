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
  version = "0.97";

  src = fetchPypi {
    inherit pname version;
    sha256 = "43eca57bb48b718ea58968608cfd22f4b9c62c2d904bb08aa2f8afe56eeb9de4";
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