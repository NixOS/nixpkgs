{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  tomli,

  # dependencies
  fastapi,
  httpx,
  mcp,
  pydantic,
  pydantic-settings,
  requests,
  rich,
  typer,
  uvicorn,

  # tests
  coverage,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "fastapi-mcp";
  version = "0.3.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tadata-org";
    repo = "fastapi_mcp";
    tag = "v${version}";
    hash = "sha256-WQ+Y/TM5fz0lHjCKvEuYGY6hzxo2ePcgRnq7piNC+KQ=";
  };

  build-system = [
    hatchling
    tomli
  ];

  dependencies = [
    fastapi
    httpx
    mcp
    pydantic
    pydantic-settings
    requests
    rich
    tomli
    typer
    uvicorn
  ];

  pythonImportsCheck = [ "fastapi_mcp" ];

  nativeCheckInputs = [
    coverage
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Flaky, would try to allocate a port on Darwin
    "tests/test_sse_real_transport.py"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Expose your FastAPI endpoints as Model Context Protocol (MCP) tools, with Auth";
    homepage = "https://github.com/tadata-org/fastapi_mcp";
    changelog = "https://github.com/tadata-org/fastapi_mcp/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
