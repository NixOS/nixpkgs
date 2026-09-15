{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,

  # build-system
  hatchling,
  uv-dynamic-versioning,

  # dependencies
  fastmcp-slim,
  fastmcp-tasks,

  # tests
  dirty-equals,
  fastapi,
  inline-snapshot,
  opentelemetry-sdk,
  psutil,
  pytest-asyncio,
  pytest-examples,
  pytest-rerunfailures,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastmcp";
  version = "4.0.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PrefectHQ";
    repo = "fastmcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WlSOcsePp0hXpwUsmYSrRaj+Amccm0usxf3uXQI7NR4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "timeout = 5" "timeout = 50"
  '';

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    fastmcp-slim
  ]
  ++ fastmcp-slim.optional-dependencies.client
  ++ fastmcp-slim.optional-dependencies.server;

  optional-dependencies = {
    anthropic = fastmcp-slim.optional-dependencies.anthropic;
    apps = fastmcp-slim.optional-dependencies.apps;
    azure = fastmcp-slim.optional-dependencies.azure;
    code-mode = fastmcp-slim.optional-dependencies.code-mode;
    gemini = fastmcp-slim.optional-dependencies.gemini;
    openai = fastmcp-slim.optional-dependencies.openai;
    tasks = [ fastmcp-tasks ];
  };

  pythonImportsCheck = [ "fastmcp" ];

  nativeCheckInputs = [
    dirty-equals
    fastapi
    inline-snapshot
    opentelemetry-sdk
    psutil
    pytest-asyncio
    pytest-examples
    pytest-rerunfailures
    pytest-timeout
    pytest-xdist
    pytestCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.anthropic
  ++ finalAttrs.passthru.optional-dependencies.apps
  ++ finalAttrs.passthru.optional-dependencies.azure
  ++ finalAttrs.passthru.optional-dependencies.code-mode
  ++ finalAttrs.passthru.optional-dependencies.gemini
  ++ finalAttrs.passthru.optional-dependencies.openai
  ++ finalAttrs.passthru.optional-dependencies.tasks
  ++ inline-snapshot.optional-dependencies.dirty-equals;

  disabledTests = [
    # Requires internet access
    "test_github_api_schema_performance"

    # Requires uv
    "test_uv_transport"
    "test_uv_transport_module"

    # Requires prefab-ui (optional dependency)
    # https://github.com/NixOS/nixpkgs/pull/510123 adds the prefab-ui package.
    "TestPrefabAppConfig"
    "test_doc_examples_quality"
    "test_run_dev_apps_log_panel_propagation"
    "test_run_dev_apps_with_host"

    # Needs pydantic-monty 0.0.18 (the version upstream pins) for
    # https://github.com/pydantic/monty/pull/424
    "test_code_mode_monty_call_tool_errors_are_catchable"

    # AssertionError: assert 'INFO' == 'DEBUG'
    "test_temporary_settings"

    # Spawning servers from an MCP config file does not work in the sandbox
    "test_run_mcp_config"
    "test_single_server_config_include_tags_filtering"

    # Subprocess-based multi-client tests fail in the sandbox
    "test_canonical_multi_client_with_transforms"
    "test_multi_client"
    "test_server_starts_without_auth"

    # mcp.shared.exceptions.MCPError: Connection closed
    "TestLogFile"
  ];

  disabledTestPaths = [
    # Requires prefab-ui (optional dependency)
    "tests/apps"
    "tests/test_apps_prefab.py"
    "tests/test_fastmcp_app.py"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Fast, Pythonic way to build MCP servers and clients";
    changelog = "https://github.com/PrefectHQ/fastmcp/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/PrefectHQ/fastmcp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
