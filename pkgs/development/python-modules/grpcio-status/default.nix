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
  version = "1.48.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "afac961fc3713889d3c48c11461aba49842ca62a54dfe8f346442046036e9856";
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
