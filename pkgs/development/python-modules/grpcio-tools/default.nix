{ lib, buildPythonPackage, fetchPypi, protobuf, grpcio, setuptools }:

buildPythonPackage rec {
  pname = "grpcio-tools";
  version = "1.48.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dd7f757608e7dfae4ab2e7fc1e8951e6eb9526ebdc7ce90597329bc4c408c9a1";
  };

  outputs = [ "out" "dev" ];

  enableParallelBuilding = true;

  propagatedBuildInputs = [ protobuf grpcio setuptools ];

  # no tests in the package
  doCheck = false;

  pythonImportsCheck = [ "grpc_tools" ];

  meta = with lib; {
    description = "Protobuf code generator for gRPC";
    license = licenses.asl20;
    homepage = "https://grpc.io/grpc/python/";
    maintainers = with maintainers; [ ];
  };
}
