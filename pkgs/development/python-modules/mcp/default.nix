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
  python-multipart,
  requests,
  rich,
  sse-starlette,
  starlette,
  typer,
  uvicorn,
  websockets,
}:

buildPythonPackage rec {
  pname = "mcp";
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "python-sdk";
    tag = "v${version}";
    hash = "sha256-UH91o2ElS0XLjH67R9QaJ/7AeX6oVkqqOc3588D4s0g=";
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
    python-multipart
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
    requests
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
    # anyio.ClosedResourceError
    "test_client_session_version_negotiation_failure"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    changelog = "https://github.com/modelcontextprotocol/python-sdk/releases/tag/${src.tag}";
    description = "Official Python SDK for Model Context Protocol servers and clients";
    homepage = "https://github.com/modelcontextprotocol/python-sdk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ josh ];
  };
}
