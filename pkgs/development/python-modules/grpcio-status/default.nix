{ lib
, buildPythonPackage
, fetchPypi
, googleapis-common-protos
, grpc
, grpcio
, protobuf
, pythonOlder
}:

buildPythonPackage rec {
  pname = "grpcio-status";
  inherit (grpc) version;
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "JVM8TWXX1ROmOPDEuIsrZnAOO/Q+aZWlWjvRXsC3eQI=";
  };

  propagatedBuildInputs = [
    googleapis-common-protos
    grpcio
    protobuf
  ];

  # Projec thas no tests
  doCheck = false;

  pythonImportsCheck = [
    "grpc_status"
  ];

  meta = with lib; {
    description = "GRPC Python status proto mapping";
    homepage = "https://github.com/grpc/grpc/tree/master/src/python/grpcio_status";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
