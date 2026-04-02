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
  version = "1.78.0";
  pyproject = true;

  src = fetchPypi {
    pname = "grpcio_tools";
    inherit version;
    hash = "sha256-Sw3YZWAnQxbhVdklFYJ2+FZFCBkwiLxD4g0/Xf+Vays=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "Cython==3.1.1" Cython
  '';

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
