{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  grpcio,
  protobuf,
}:

# This package should be updated together with the main grpc package and other
# related python grpc packages.
# nixpkgs-update: no auto update
buildPythonPackage rec {
  pname = "grpcio-reflection";
  version = "1.84.0";
  pyproject = true;

  src = fetchPypi {
    pname = "grpcio_reflection";
    inherit version;
    hash = "sha256-Br89fYzvmvvMch7lIZFlK0SDgxd0JV4XRASw4FUXQbw=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "grpcio"
    "protobuf"
  ];

  dependencies = [
    grpcio
    protobuf
  ];

  pythonImportsCheck = [ "grpc_reflection" ];

  # no tests
  doCheck = false;

  meta = {
    description = "Standard Protobuf Reflection Service for gRPC";
    homepage = "https://pypi.org/project/grpcio-reflection";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
