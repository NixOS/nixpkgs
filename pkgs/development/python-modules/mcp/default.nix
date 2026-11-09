{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  uv-dynamic-versioning,

  # dependencies
  anyio,
  httpx2,
  jsonschema,
  mcp-types,
  opentelemetry-api,
  pydantic,
  pyjwt,
  python-multipart,
  sse-starlette,
  starlette,
  typing-extensions,
  typing-inspection,
  uvicorn,

  # optional-dependencies
  # cli
  python-dotenv,
  typer,
  # rich
  rich,

  # tests
  blockbuster,
  coverage,
  dirty-equals,
  griffelib,
  inline-snapshot,
  logfire,
  opentelemetry-sdk,
  pytest-asyncio,
  pytest-examples,
  pytest-xdist,
  pytestCheckHook,
  pyyaml,
  trio,
  zensical,
}:

buildPythonPackage (finalAttrs: {
  pname = "mcp";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "python-sdk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CnXi78zYxm0/R4fON/DzRYMSDYM/XM/9SE3s+Cf1BR0=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    anyio
    httpx2
    jsonschema
    mcp-types
    opentelemetry-api
    pydantic
    pyjwt
    python-multipart
    sse-starlette
    starlette
    typing-extensions
    typing-inspection
    uvicorn
  ]
  ++ pyjwt.optional-dependencies.crypto;

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
    blockbuster
    coverage
    dirty-equals
    griffelib
    inline-snapshot
    logfire
    opentelemetry-sdk
    pytest-asyncio
    pytest-examples
    pytest-xdist
    pytestCheckHook
    pyyaml
    trio
    zensical
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  # tests import examples/stories
  preCheck = ''
    export PYTHONPATH="$PWD/examples:$PYTHONPATH"
  '';

  disabledTests = [
    # spawned server doesn't inherit PYTHONPATH
    "test_client_with_stdio_parameters_launches_the_server_as_a_subprocess"
    "test_tool_call_and_notification_round_trip_over_a_stdio_subprocess"
    "test_a_tool_spawned_childs_stdout_writes_never_reach_the_wire"

    # Flaky: https://github.com/modelcontextprotocol/python-sdk/pull/1171
    "test_notification_validation_error"

    # Flaky: httpx.ConnectError: All connection attempts failed
    "test_sse_security_"
    "test_streamable_http_"
    "test_streamablehttp_"

    # This just feels a bit optimistic...
    #     	assert duration < 3 * _sleep_time_seconds
    # AssertionError: assert 0.0733884589999434 < (3 * 0.01)
    "test_messages_are_executed_concurrently"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    changelog = "https://github.com/modelcontextprotocol/python-sdk/releases/tag/${finalAttrs.src.tag}";
    description = "Official Python SDK for Model Context Protocol servers and clients";
    homepage = "https://github.com/modelcontextprotocol/python-sdk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      bryanhonof
    ];
  };
})
