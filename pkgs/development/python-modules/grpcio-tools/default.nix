{
  lib,
  buildPythonPackage,
  fetchPypi,
  protobuf,
  cython,
  grpcio,
  setuptools,
}:

# This package should be updated together with the main grpc package and other
# related python grpc packages.
# nixpkgs-update: no auto update
buildPythonPackage rec {
  pname = "grpcio-tools";
  version = "1.85.1";
  pyproject = true;

  src = fetchPypi {
    pname = "grpcio_tools";
    inherit version;
    hash = "sha256-1vHuIToH3pRiyQ7l3r5KeN/yAwag+zlKZdSLL5T+MaE=";
  };

  outputs = [
    "out"
    "dev"
  ];

  enableParallelBuilding = true;

  build-system = [
    cython
    setuptools
  ];

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

  meta = {
    description = "Protobuf code generator for gRPC";
    license = lib.licenses.asl20;
    homepage = "https://grpc.io/grpc/python/";
    maintainers = [ ];
  };
}
