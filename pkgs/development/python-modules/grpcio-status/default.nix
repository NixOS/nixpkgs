{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  googleapis-common-protos,
  grpcio,
  protobuf,
}:

# This package should be updated together with the main grpc package and other
# related python grpc packages.
# nixpkgs-update: no auto update
buildPythonPackage (finalAttrs: {
  pname = "grpcio-status";
  version = "1.83.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "grpcio_status";
    inherit (finalAttrs) version;
    hash = "sha256-g3IZxt6a/cy29vcrNLxx4VGiAR7wQEDj+qynRqV+VK4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    googleapis-common-protos
    grpcio
    protobuf
  ];

  # Project thas no tests
  doCheck = false;

  pythonImportsCheck = [ "grpc_status" ];

  meta = {
    description = "GRPC Python status proto mapping";
    homepage = "https://github.com/grpc/grpc/tree/master/src/python/grpcio_status";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
