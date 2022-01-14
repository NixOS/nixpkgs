{ lib
, buildPythonPackage
, fetchPypi
, grpc
, protobuf
}:

buildPythonPackage rec {
  pname = "googleapis-common-protos";
  version = "1.54.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a4031d6ec6c2b1b6dc3e0be7e10a1bd72fb0b18b07ef9be7b51f2c1004ce2437";
  };

  propagatedBuildInputs = [ grpc protobuf ];

  # does not contain tests
  doCheck = false;

  pythonImportsCheck = [
    "google.api"
    "google.logging"
    "google.longrunning"
    "google.rpc"
    "google.type"
  ];

  meta = with lib; {
    description = "Common protobufs used in Google APIs";
    homepage = "https://github.com/googleapis/python-api-common-protos";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
