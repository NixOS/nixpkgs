{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "requests-sse";
  version = "0.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "overcat";
    repo = "requests-sse";
    tag = finalAttrs.version;
    hash = "sha256-+Zv7k+cYux7aBZk9MN7ySZh+pQUHNa6KjwxQ4l4aFxA=";
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
