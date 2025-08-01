{
  lib,
  stdenv,
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
  inline-snapshot,
  pytest-asyncio,
  pytest-examples,
  pytest-xdist,
  pytestCheckHook,
  requests,
}:

buildPythonPackage rec {
  pname = "mcp";
  version = "1.9.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "python-sdk";
    tag = "v${version}";
    hash = "sha256-VXbu/wHbXGS+cISJVUgCVEpTmZc0VfckNRoMj3GDi/A=";
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
    inline-snapshot
    pytest-asyncio
    pytest-examples
    pytest-xdist
    pytestCheckHook
    requests
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

  pytestFlags = [
    "-Wignore::pydantic.warnings.PydanticDeprecatedSince211"
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

    # inline_snapshot._exceptions.UsageError: snapshot value should not change. Use Is(...) for dynamic snapshot parts
    "test_build_metadata"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Flaky: ExceptionGroup: unhandled errors in a TaskGroup (1 sub-exception)
    "test_notification_validation_error"
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
