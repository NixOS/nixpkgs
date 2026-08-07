{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  uv-dynamic-versioning,

  # dependencies
  httpx,
  logfire-api,
  pydantic,
  typing-inspection,
}:

# Update together with pydantic-ai-slim
# nixpkgs-update: no auto update

buildPythonPackage (finalAttrs: {
  pname = "pydantic-graph";
  version = "2.21.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic-ai";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hcCGy0Ke9kYit4vMyIWCz6q+EbIOFQmk0CQIBXWNcGU=";
  };

  sourceRoot = "${finalAttrs.src.name}/pydantic_graph";

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    httpx
    logfire-api
    pydantic
    typing-inspection
  ];

  pythonImportsCheck = [
    "pydantic_graph"
  ];

  doCheck = false; # no tests

  meta = {
    changelog = "https://github.com/pydantic/pydantic-ai/releases/tag/${finalAttrs.src.tag}";
    description = "GenAI Agent Framework, the Pydantic way";
    homepage = "https://github.com/pydantic/pydantic-ai";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
