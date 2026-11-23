{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  google-api-core,
  grpcio,
  grpcio-tools,
  protobuf,
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

  build-system = [ setuptools ];

  nativeBuildInputs = [ grpcio-tools ];

  preBuild = ''
    make -C api/python pre-build common gw api integration stream
    cd api/python/src
  '';

  dependencies = [
    google-api-core
    grpcio
    protobuf
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "chirpstack_api"
    "chirpstack_api.api"
    "chirpstack_api.common"
    "chirpstack_api.gw"
    "chirpstack_api.integration"
    "chirpstack_api.stream"
  ];

  meta = {
    description = "ChirpStack gRPC API message and service wrappers for Python";
    homepage = "https://github.com/chirpstack/chirpstack";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
