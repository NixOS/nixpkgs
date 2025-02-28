{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pydantic,
  logfire-api,
  httpx,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pydantic-graph";
  version = "0.0.29";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic-ai";
    tag = "v${version}";
    hash = "sha256-UT2Nls4JRy2grefIn+1z2V/YxWnrl0uzzjIkpqyDGZM=";
  };

  sourceRoot = "source/pydantic_graph";

  build-system = [
    hatchling
  ];

  dependencies = [
    pydantic
    logfire-api
    httpx
  ];

  nativeCheckInputs = [
    pydantic
    logfire-api
    httpx
  ];

  pythonImportsCheck = [
    "pydantic_graph"
  ];

  meta = {
    description = "PydanticAI core logic with minimal required dependencies.";
    homepage = "https://github.com/pydantic/pydantic-ai";
    changelog = "https://github.com/pydantic/pydantic-ai/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yomaq ];
  };
}
