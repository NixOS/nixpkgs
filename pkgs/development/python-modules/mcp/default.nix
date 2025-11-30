{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  uv-dynamic-versioning,

  # dependencies
  anyio,
  httpx,
  httpx-sse,
  jsonschema,
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
  dirty-equals,
  inline-snapshot,
  pytest-asyncio,
  pytest-examples,
  pytest-xdist,
  pytestCheckHook,
  requests,
}:

buildPythonPackage rec {
  pname = "mcp";
  version = "1.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "python-sdk";
    tag = "v${version}";
    hash = "sha256-pvbrNkGfQaZX95JZyYXuuH2gMzWouuGXjaDxPyKW0Zw=";
  };

  postPatch = lib.optionalString stdenv.buildPlatform.isDarwin ''
    # time.sleep(0.1) feels a bit optimistic and it has been flaky whilst
    # testing this on macOS under load.
    substituteInPlace \
      "tests/client/test_stdio.py" \
      "tests/server/fastmcp/test_integration.py" \
      "tests/shared/test_ws.py" \
      "tests/shared/test_sse.py" \
      "tests/shared/test_streamable_http.py" \
      --replace-fail "time.sleep(0.1)" "time.sleep(1)"
  '';

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  pythonRelaxDeps = [
    "pydantic-settings"
  ];

  dependencies = [
    anyio
    httpx
    httpx-sse
    jsonschema
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
    dirty-equals
    inline-snapshot
    pytest-asyncio
    pytest-examples
    pytest-xdist
    pytestCheckHook
    requests
  ]
  ++ lib.concatAttrValues optional-dependencies;

  disabledTests = [
    # attempts to run the package manager uv
    "test_command_execution"

    # ExceptionGroup: unhandled errors in a TaskGroup (1 sub-exception)
    "test_lifespan_cleanup_executed"

    # AssertionError: Child process should be writing
    "test_basic_child_process_cleanup"

    # AssertionError: parent process should be writing
    "test_nested_process_tree"

    # AssertionError: Child should be writing
    "test_early_parent_exit"

    # pytest.PytestUnraisableExceptionWarning: Exception ignored in: <_io.FileIO ...
    "test_list_tools_returns_all_tools"

    # AssertionError: Server startup marker not created
    "test_stdin_close_triggers_cleanup"

    # pytest.PytestUnraisableExceptionWarning: Exception ignored in: <function St..
    "test_resource_template_client_interaction"

    # Flaky: https://github.com/modelcontextprotocol/python-sdk/pull/1171
    "test_notification_validation_error"

    # Flaky: httpx.ConnectError: All connection attempts failed
    "test_sse_security_"
    "test_streamable_http_"

    # This just feels a bit optimistic...
    #     	assert duration < 3 * _sleep_time_seconds
    # AssertionError: assert 0.0733884589999434 < (3 * 0.01)
    "test_messages_are_executed_concurrently"

    # ExceptionGroup: unhandled errors in a TaskGroup (1 sub-exception)
    "test_tool_progress"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    changelog = "https://github.com/modelcontextprotocol/python-sdk/releases/tag/${src.tag}";
    description = "Official Python SDK for Model Context Protocol servers and clients";
    homepage = "https://github.com/modelcontextprotocol/python-sdk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      bryanhonof
      josh
    ];
  };
}
