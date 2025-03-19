{
  anyio,
  buildPythonPackage,
  coreutils,
  fetchFromGitHub,
  hatchling,
  httpx,
  httpx-sse,
  lib,
  pydantic,
  pydantic-settings,
  pytest-asyncio,
  pytestCheckHook,
  python-dotenv,
  rich,
  sse-starlette,
  starlette,
  typer,
  uvicorn,
}:

buildPythonPackage rec {
  pname = "mcp";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "python-sdk";
    tag = "v${version}";
    hash = "sha256-DbRXD4o/uFfpGvrux8lm7/t2utdFDEFg2G7CiraCJd0=";
  };

  postPatch = ''
    substituteInPlace tests/client/test_stdio.py \
      --replace '/usr/bin/tee' '${lib.getExe' coreutils "tee"}'
  '';

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    "pydantic-settings"
  ];

  dependencies = [
    anyio
    httpx
    httpx-sse
    pydantic
    pydantic-settings
    sse-starlette
    starlette
    uvicorn
  ];

  optional-dependencies = {
    cli = [
      python-dotenv
      typer
    ];
    rich = [
      rich
    ];
  };

  pythonImportsCheck = [ "mcp" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  disabledTests = [
    # attempts to run the package manager uv
    "test_command_execution"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    changelog = "https://github.com/modelcontextprotocol/python-sdk/releases/tag/${src.tag}";
    description = "Official Python SDK for Model Context Protocol servers and clients";
    homepage = "https://github.com/modelcontextprotocol/python-sdk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
