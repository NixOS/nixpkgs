{ lib
, buildPythonPackage
, fetchPypi
, grpc
, protobuf
}:

buildPythonPackage rec {
  pname = "googleapis-common-protos";
  version = "1.56.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-sJtW9UYwcMIVN1PvEj8H0uSSNeiRSOmyRZ7I7S9o19M=";
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
