{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "requests-sse";
  version = "0.6.0b0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "overcat";
    repo = "requests-sse";
    tag = finalAttrs.version;
    hash = "sha256-JflM6Rx9TFS7EsusqBJViDvk3X3YAawzI75jn84cbZM=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    requests
  ];

  pythonImportsCheck = [
    "requests_sse"
  ];

  # tests require internet access
  doCheck = false;

  meta = {
    description = "Server-sent events python client library based on requests";
    homepage = "https://github.com/overcat/requests-sse";
    changelog = "https://github.com/overcat/requests-sse/blob/${finalAttrs.src.rev}/CHANGES.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
