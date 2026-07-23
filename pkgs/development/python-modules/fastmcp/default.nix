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
  azure-identity,
  cyclopts,
  exceptiongroup,
  httpx,
  jsonref,
  jsonschema-path,
  mcp,
  fakeredis,
  google-genai,
  openai,
  openapi-pydantic,
  opentelemetry-api,
  packaging,
  platformdirs,
  py-key-value-aio,
  pydantic,
  pydantic-monty,
  pydocket,
  pyjwt,
  pyperclip,
  python-dotenv,
  pyyaml,
  rich,
  uncalled-for,
  uvicorn,
  watchfiles,
  websockets,

  # tests
  dirty-equals,
  email-validator,
  fastapi,
  inline-snapshot,
  lupa,
  opentelemetry-sdk,
  psutil,
  pytest-asyncio,
  pytest-httpx,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastmcp";
  version = "3.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jlowin";
    repo = "fastmcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YfFAJvfKLOgfGFWyQmR4FGHrRc066Y0mAYhXJqJ9vyw=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  pythonRelaxDeps = [
    "py-key-value-aio"
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
    opentelemetry-api
    packaging
    platformdirs
    py-key-value-aio
    pydantic
    pyperclip
    python-dotenv
    pyyaml
    rich
    uncalled-for
    uvicorn
    watchfiles
    websockets
  ]
  ++ py-key-value-aio.optional-dependencies.filetree
  ++ py-key-value-aio.optional-dependencies.keyring
  ++ py-key-value-aio.optional-dependencies.memory
  ++ pydantic.optional-dependencies.email;

  optional-dependencies = {
    anthropic = [ anthropic ];
    azure = [
      azure-identity
      pyjwt
    ];
    code-mode = [ pydantic-monty ];
    gemini = [ google-genai ];
    openai = [ openai ];
    tasks = [
      pydocket
      fakeredis
    ]
    ++ fakeredis.optional-dependencies.lua;
  };

  pythonImportsCheck = [ "fastmcp" ];

  nativeCheckInputs = [
    dirty-equals
    email-validator
    fastapi
    inline-snapshot
    lupa
    opentelemetry-sdk
    psutil
    pytest-asyncio
    pytest-httpx
    pytestCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.anthropic
  ++ finalAttrs.passthru.optional-dependencies.azure
  ++ finalAttrs.passthru.optional-dependencies.code-mode
  ++ finalAttrs.passthru.optional-dependencies.gemini
  ++ finalAttrs.passthru.optional-dependencies.openai
  ++ inline-snapshot.optional-dependencies.dirty-equals;

  disabledTests = [
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

    # Requires prefab-ui (optional dependency)
    "test_auto_registers_renderer_resource"
    "test_equivalent_to_app_true"

    # Requires pydocket (tasks optional dependency, not in test inputs)
    "test_mounted_server_does_not_have_docket"
    "test_get_tasks_returns_task_eligible_tools"
    "test_task_teardown_does_not_hang"
    "test_background_task_can_read_snapshotted_request_headers"
    "test_background_task_current_http_dependencies_restore_headers"
    "test_task_execution_auto_populated_for_task_enabled_tool"
    "test_function_tool_task_config_still_works"
    "test_async_partial_with_task_true_does_not_raise"
    "test_sync_partial_with_task_true_raises"
    "test_is_docket_available"
    "test_require_docket_passes_when_installed"

    # Shared dependency caching differs in sandbox
    "TestSharedDependencies"

    # AssertionError: assert 'INFO' == 'DEBUG'
    "test_temporary_settings"

    # Subprocess-based multi-client tests fail in sandbox
    "test_multi_client"
    "test_multi_server"
    "test_single_server_config_include_tags_filtering"
    "test_server_starts_without_auth"
    "test_canonical_multi_client_with_transforms"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # RuntimeError: Server failed to start after 10 attempts
    "test_unauthorized_access"
    "test_stateless_proxy"
  ];

  disabledTestPaths = [
    # Requires prefab-ui (optional dependency)
    "tests/apps"
    "tests/test_apps_prefab.py"
    "tests/test_fastmcp_app.py"
    # Subprocess crash recovery tests are flaky in sandbox
    "tests/client/test_stdio.py"
    # Requires pydocket/fakeredis (tasks optional dependency, not in test inputs)
    "tests/server/tasks"
    "tests/server/test_server_docket.py"
    "tests/client/tasks"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
