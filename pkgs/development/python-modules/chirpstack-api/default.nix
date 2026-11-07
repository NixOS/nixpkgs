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
  version = "4.20.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-be2RT+lQvZc0+GbihpLwPgMXb4qOF+xWQ45tuvul0Rg=";
  };

  sourceRoot = "${finalAttrs.src.name}/api/python/src";

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
    homepage = "https://github.com/chirpstack/chirpstack";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
