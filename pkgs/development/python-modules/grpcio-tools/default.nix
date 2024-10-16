{
  lib,
  buildPythonPackage,
  fetchPypi,
  protobuf,
  grpcio,
  setuptools,
}:

buildPythonPackage rec {
  pname = "grpcio-tools";
  version = "1.66.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "grpcio_tools";
    inherit version;
    hash = "sha256-UFX/6EDqj1BcMDeL4Cr7Tb7LM0gOVU3r4Qtj1rL2QcM=";
  };

  outputs = [
    "out"
    "dev"
  ];

  enableParallelBuilding = true;

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "protobuf"
    "grpcio"
  ];

  dependencies = [
    protobuf
    grpcio
    setuptools
  ];

  # no tests in the package
  doCheck = false;

  pythonImportsCheck = [ "grpc_tools" ];

  meta = with lib; {
    description = "Protobuf code generator for gRPC";
    license = licenses.asl20;
    homepage = "https://grpc.io/grpc/python/";
    maintainers = [ ];
  };
}
