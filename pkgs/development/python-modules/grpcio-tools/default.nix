{
  lib,
  buildPythonPackage,
  fetchPypi,
  protobuf,
  grpcio,
  setuptools,
}:

# This package should be updated together with the main grpc package and other
# related python grpc packages.
# nixpkgs-update: no auto update
buildPythonPackage rec {
  pname = "grpcio-tools";
  version = "1.66.2";
  format = "setuptools";

  src = fetchPypi {
    pname = "grpcio_tools";
    inherit version;
    hash = "sha256-SjbgeRPSa6XM/SaFumPKl/JrCMJJ0syedN2jfvpJ1+Q=";
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
