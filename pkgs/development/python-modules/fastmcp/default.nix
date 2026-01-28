{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,

  # build-system
  hatchling,
  uv-dynamic-versioning,

  # dependencies
  anthropic,
  authlib,
  cyclopts,
  exceptiongroup,
  httpx,
  jsonref,
  jsonschema-path,
  mcp,
  openai,
  openapi-pydantic,
  packaging,
  platformdirs,
  py-key-value-aio,
  pydantic,
  pydocket,
  pyperclip,
  python-dotenv,
  rich,
  uvicorn,
  websockets,

  # tests
  dirty-equals,
  email-validator,
  fastapi,
  inline-snapshot,
  lupa,
  psutil,
  pytest-asyncio,
  pytest-httpx,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastmcp";
  version = "2.14.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jlowin";
    repo = "fastmcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qJdOKLvxjenNCyya+XMrf3NGMaDL9LM9HsaQrhubXIY=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  pythonRelaxDeps = [
    "pydocket"
  ];
  dependencies = [
    authlib
    cyclopts
    exceptiongroup
    httpx
    jsonref
    jsonschema-path
    mcp
    openapi-pydantic
    packaging
    platformdirs
    py-key-value-aio
    pydantic
    pydocket
    pyperclip
    python-dotenv
    rich
    uvicorn
    websockets
  ]
  ++ py-key-value-aio.optional-dependencies.disk
  ++ py-key-value-aio.optional-dependencies.keyring
  ++ py-key-value-aio.optional-dependencies.memory
  ++ pydantic.optional-dependencies.email;

  optional-dependencies = {
    anthropic = [ anthropic ];
    openai = [ openai ];
  };

  pythonImportsCheck = [ "fastmcp" ];

  nativeCheckInputs = [
    dirty-equals
    email-validator
    fastapi
    inline-snapshot
    lupa
    psutil
    pytest-asyncio
    pytest-httpx
    pytestCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies
  ++ inline-snapshot.optional-dependencies.dirty-equals;

  disabledTests = [
    # redis.exceptions.ResponseError: unknown command `evalsha`, with args beginning with:
    "test_get_prompt_as_task_returns_prompt_task"
    "test_prompt_task_server_generated_id"

    "test_logging_middleware_with_payloads"
    "test_structured_logging_middleware_produces_json"

    # AssertionError: assert 'INFO' == 'DEBUG'
    "test_temporary_settings"

    # mcp.shared.exceptions.McpError: Connection closed
    "test_log_file_captures_stderr_output_with_path"
    "test_log_file_captures_stderr_output_with_textio"
    "test_log_file_none_uses_default_behavior"

    # RuntimeError: Client failed to connect: Connection closed
    "test_keep_alive_maintains_session_across_multiple_calls"
    "test_keep_alive_false_starts_new_session_across_multiple_calls"
    "test_keep_alive_false_exit_scope_kills_server"
    "test_keep_alive_starts_new_session_if_manually_closed"
    "test_keep_alive_true_exit_scope_kills_client"
    "test_keep_alive_maintains_session_if_reentered"
    "test_close_session_and_try_to_use_client_raises_error"
    "test_parallel_calls"
    "test_run_mcp_config"
    "test_settings_from_environment_issue_1749"
    "test_uv_transport"
    "test_uv_transport_module"
    "test_github_api_schema_performance"

    # Hang forever
    "test_nested_streamable_http_server_resolves_correctly"

    # RuntimeError: Client failed to connect: Timed out while waiting for response
    "test_timeout"
    "test_timeout_tool_call_overrides_client_timeout_even_if_lower"

    # assert 0 == 2
    "test_multi_client"
    "test_canonical_multi_client_with_transforms"

    # AssertionError: assert {'annotations...object'}, ...} == {'annotations...sers']}}, ...}
    "test_list_tools"

    # AssertionError: assert len(caplog.records) == 1
    "test_log"

    #  assert [TextContent(...e, meta=None)] == [TextContent(...e, meta=None)]
    "test_read_resource_tool_works"

    # fastmcp.exceptions.ToolError: Unknown tool
    "test_multi_client_with_logging"
    "test_multi_client_with_elicitation"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # RuntimeError: Server failed to start after 10 attempts
    "test_unauthorized_access"
  ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # RuntimeError: Server failed to start after 10 attempts
    "tests/client/auth/test_oauth_client.py"
    "tests/client/test_sse.py"
    "tests/client/test_streamable_http.py"
    "tests/server/auth/test_jwt_provider.py"
    "tests/server/http/test_http_dependencies.py"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Fast, Pythonic way to build MCP servers and clients";
    changelog = "https://github.com/jlowin/fastmcp/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/jlowin/fastmcp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
