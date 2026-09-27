{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  grpcio,
}:

buildPythonPackage (finalAttrs: {
  pname = "grpcio-gcp";
  version = "0.2.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "grpcio-gcp";
    inherit (finalAttrs) version;
    hash = "sha256-4pJgXv/H2jm3qHNMcZr7EuxLU2Kt01KNivrTqjqpBXw=";
  };

  build-system = [ setuptools ];

  dependencies = [ grpcio ];

  meta = {
    description = "gRPC extensions for Google Cloud Platform";
    homepage = "https://grpc.io";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
