{ lib
, buildPythonPackage
, fetchPypi
, grpc
, protobuf
}:

buildPythonPackage rec {
  pname = "googleapis-common-protos";
  version = "1.55.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-U+sxMGRzj0XVrGNBVa4gjhIcljZZYnuQ38th71FMA+E=";
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
