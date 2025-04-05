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
  pytest-examples,
  pytestCheckHook,
  python-dotenv,
  rich,
  sse-starlette,
  starlette,
  typer,
  uvicorn,
  websockets,
}:

buildPythonPackage rec {
  pname = "mcp";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "python-sdk";
    tag = "v${version}";
    hash = "sha256-Z2NN6k4mD6NixDON1MUOELpBZW9JvMvFErcCbFPdg2o=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "uv-dynamic-versioning"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
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
    ws = [
      websockets
    ];
  };

  pythonImportsCheck = [ "mcp" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-examples
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  pytestFlagsArray = [
    "-W"
    "ignore::pydantic.warnings.PydanticDeprecatedSince211"
  ];

  disabledTests = [
    # attempts to run the package manager uv
    "test_command_execution"
    # performance-dependent test
    "test_messages_are_executed_concurrently"
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
