{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  anyio,
  httpx,
  httpx-sse,
  pydantic,
  pydantic-settings,
  python-multipart,
  sse-starlette,
  starlette,
  uvicorn,

  # optional-dependencies
  # cli
  python-dotenv,
  typer,
  # rich
  rich,
  # ws
  websockets,

  # tests
  pytest-asyncio,
  pytest-examples,
  pytestCheckHook,
  requests,
}:

buildPythonPackage rec {
  pname = "mcp";
  version = "1.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "python-sdk";
    tag = "v${version}";
    hash = "sha256-8u02/tHR2F1CpjcHXHC8sZC+/JrWz1satqYa/zdSGDw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "uv-dynamic-versioning"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
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
    python-multipart
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

    # ExceptionGroup: unhandled errors in a TaskGroup (1 sub-exception)
    "test_client_session_version_negotiation_failure"

    # AttributeError: 'coroutine' object has no attribute 'client_metadata'
    "TestOAuthClientProvider"
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
