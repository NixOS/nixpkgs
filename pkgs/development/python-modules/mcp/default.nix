{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  hatchling,
  anyio,
  httpx-sse,
  httpx,
  pydantic-settings,
  pydantic,
  sse-starlette,
  starlette,
  uvicorn,
}:

buildPythonPackage rec {
  pname = "mcp";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KwbH7OmNbqnmN5yqONdLQyOFwzj7Uwy4Lixw6nrdlPU=";
  };

  build-system = [ hatchling ];

  dependencies = [
    anyio
    httpx-sse
    httpx
    pydantic-settings
    pydantic
    sse-starlette
    starlette
    uvicorn
  ];

  pythonImportsCheck = [ "mcp" ];

  meta = {
    description = "Python implementation of the Model Context Protocol (MCP)";
    homepage = "https://github.com/modelcontextprotocol/python-sdk";
    changelog = "https://github.com/modelcontextprotocol/python-sdk/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gaelj ];
  };
}
