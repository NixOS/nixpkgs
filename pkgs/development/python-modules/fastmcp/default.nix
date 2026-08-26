{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  writableTmpDirAsHomeHook,

  # build-system
  hatchling,
  uv-dynamic-versioning,

  # dependencies
  fastmcp-slim,

  # tests
  dirty-equals,
  fastapi,
  inline-snapshot,
  opentelemetry-sdk,
  psutil,
  pytest-asyncio,
  pytest-examples,
  pytest-httpx,
  pytest-rerunfailures,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastmcp";
  version = "3.4.7";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PrefectHQ";
    repo = "fastmcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EysVbtFbop5ENupc9T5EmtUSZ8osVtQSzpwa6rea/OQ=";
  };

  patches = [
    # Fix python 3.14 compatibility (https://github.com/PrefectHQ/fastmcp/pull/4796)
    # TODO: remove when updating to the next release
    (fetchpatch {
      url = "https://github.com/PrefectHQ/fastmcp/commit/6be0ac8e15d35ff8f5121266855bc34c1158c9a1.patch";
      includes = [ "fastmcp_slim/fastmcp/tools/function_tool.py" ];
      hash = "sha256-7N86b5sslWLgoB2dS2Xh3JfZX3oTHeXfeSJOaWKI5b0=";
    })
  ];

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
    tasks = fastmcp-slim.optional-dependencies.tasks;
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
    pytest-httpx
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
    # requires internet
    "test_github_api_schema_performance"

    # RuntimeError: Client failed to connect: Connection closed
    "test_single_server_config_include_tags_filtering"
    "test_run_mcp_config"

    # requires uv
    "test_uv_transport"
    "test_uv_transport_module"

    # Hang forever
    "test_nested_streamable_http_server_resolves_correctly"

    # Requires prefab-ui (optional dependency)
    # https://github.com/NixOS/nixpkgs/pull/510123 adds the prefab-ui package.
    "TestPrefabAppConfig"
    "test_doc_examples_quality"
    "test_run_dev_apps_with_host"
    "test_run_dev_apps_log_panel_propagation"

    # AssertionError: assert 'INFO' == 'DEBUG'
    "test_temporary_settings"

    # Subprocess-based multi-client tests fail in sandbox
    "test_multi_client"
    "test_multi_server"
    "test_server_starts_without_auth"
    "test_canonical_multi_client_with_transforms"

    # Server startup is flaky when the suite runs with pytest-xdist
    "test_unauthorized_access"

    # Timing-sensitive and flaky
    "test_rate_limiting_recovery_over_time"
    "test_rate_limiting_with_different_operations"
    "test_timeout"

    # RuntimeError: Attempted to exit a cancel scope that isn't the current tasks's current cancel scope
    "test_stateful_proxy"
    "test_concurrent_log_requests_no_mixing"
    "test_multi_proxies_no_mixing"
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch64 [
    # floating point error
    "test_index_retrieval[float32-quantization1-1-metric0-3]"
  ];

  disabledTestPaths = [
    # Requires prefab-ui (optional dependency)
    "tests/apps"
    "tests/test_apps_prefab.py"
    "tests/test_fastmcp_app.py"
    # Subprocess crash recovery tests are flaky in sandbox
    "tests/client/test_stdio.py"
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
