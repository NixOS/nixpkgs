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
  # ws
  websockets,

  # tests
  coverage,
  dirty-equals,
  inline-snapshot,
  logfire,
  pytest-asyncio,
  pytest-examples,
  pytest-xdist,
  pytestCheckHook,
  requests,
  trio,
}:

buildPythonPackage (finalAttrs: {
  pname = "mcp";
  version = "2.2.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "python-sdk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nnpNXnQiFSGx5KQBDXHCOH0wE3cznlmI6s7vtchcj3A=";
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
    ws = [
      websockets
    ];
  };

  pythonImportsCheck = [ "mcp" ];

  nativeCheckInputs = [
    coverage
    dirty-equals
    inline-snapshot
    logfire
    pytest-asyncio
    pytest-examples
    pytest-xdist
    pytestCheckHook
    requests
    trio
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pytestFlags = [
    "-Wignore::pytest.PytestRemovedIn10Warning"
  ];

  disabledTests = [
    # `stdio_client` only forwards a fixed allowlist of environment variables to
    # the server it spawns, so the child does not inherit PYTHONPATH and cannot
    # import `mcp`
    "test_a_tool_spawned_childs_stdout_writes_never_reach_the_wire"
    "test_client_with_stdio_parameters_launches_the_server_as_a_subprocess"
    "test_tool_call_and_notification_round_trip_over_a_stdio_subprocess"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # The test assumes `json.loads` raises `RecursionError` on a 100k-deep body,
    # but it parses fine here, so the server answers INVALID_REQUEST
    "test_modern_post_with_deeply_nested_body_is_parse_error_not_a_crash"
  ];

  disabledTestPaths = [
    # Exercise the docs tooling, which needs the (unpackaged) zensical stack
    "tests/docs"

    # Require the `mcp-example-stories` workspace package
    "tests/examples"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    changelog = "https://github.com/modelcontextprotocol/python-sdk/releases/tag/${finalAttrs.src.tag}";
    description = "Official Python SDK for Model Context Protocol servers and clients";
    homepage = "https://github.com/modelcontextprotocol/python-sdk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      bryanhonof
      josh
    ];
  };
})
