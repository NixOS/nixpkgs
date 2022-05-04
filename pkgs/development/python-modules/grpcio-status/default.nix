{ lib
, buildPythonPackage
, fetchPypi
, googleapis-common-protos
, grpcio
, protobuf
, pythonOlder
}:

buildPythonPackage rec {
  pname = "grpcio-status";
  version = "1.46.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fe80131b83724e7f9818eaa54a49906348ca8d1f636b6331de2fc19a9cac3cb1";
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
