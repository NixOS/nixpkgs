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

buildPythonPackage (finalAttrs: {
  pname = "pydantic-graph";
  version = "1.88.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic-ai";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2DyPJNbGFkbgYd2qLqhlTkmsgpLcTkkq3+7JKMocnBk=";
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
    description = "GenAI Agent Framework, the Pydantic way";
    homepage = "https://github.com/pydantic/pydantic-ai";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
