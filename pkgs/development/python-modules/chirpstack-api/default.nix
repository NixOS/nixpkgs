{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  google-api-core,
  grpcio,
}:

buildPythonPackage (finalAttrs: {
  pname = "chirpstack-api";
  version = "3.12.5";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "brocaar";
    repo = "chirpstack-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TDwvUNnGAbt10lLg6U7q+JMg7uu8TLySYqNyt/uk8UY=";
  };

  sourceRoot = "${finalAttrs.src.name}/python/src";

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    grpcio
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "chirpstack_api" ];

  meta = {
    description = "ChirpStack gRPC API message and service wrappers for Python";
    homepage = "https://github.com/brocaar/chirpstack-api";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
