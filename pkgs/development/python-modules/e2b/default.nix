{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  uv-build,

  # dependencies
  attrs,
  connectrpc,
  dockerfile-parse,
  e2b-dockerfile-utils,
  h2,
  httpx,
  packaging,
  protobuf-py,
  pyqwest,
  python-dateutil,
  rich,
  typing-extensions,
  wcmatch,

  # tests
  pytest-asyncio,
  pytest-timeout,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "e2b";
  version = "2.63.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "e2b-dev";
    repo = "E2B";
    tag = "@e2b/python-sdk@${finalAttrs.version}";
    hash = "sha256-+phem2IV9lc+V5j5wEpAcH4364wjX8bzOjjWGuvsA0Q=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/python-sdk";

  # Upstream caps the build backend at uv_build<0.11.0; ours is newer.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.13.4,<0.14.0" "uv_build"
  '';

  pythonRelaxDeps = [
    "connectrpc"
    "protobuf-py"
    "pyqwest"
    "h2"
  ];

  build-system = [
    uv-build
  ];

  dependencies = [
    attrs
    connectrpc
    dockerfile-parse
    e2b-dockerfile-utils
    h2
    httpx
    packaging
    protobuf-py
    pyqwest
    python-dateutil
    rich
    typing-extensions
    wcmatch
  ];

  pythonImportsCheck = [ "e2b" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  # Everything under tests/{async,sync,bugs} drives a real sandbox and needs an
  # API key. The rest runs offline against an in-process envd frame server.
  enabledTestPaths = [ "tests/test_*.py" ];

  disabledTests = [
    # TypeError
    "test_async_completed_stream_does_not_send_rst_stream"
    "test_async_dropped_connection_redials_for_the_health_probe"
    "test_async_early_close_propagates_through_logging_interceptor"
    "test_async_early_close_sends_rst_stream"
    "test_async_envd_dials_connections_as_streams_fill_them"
    "test_async_envd_waits_for_a_stream_at_the_connection_cap"
    "test_async_kill_returns_false_on_plain_http_404"
    "test_async_setup_timeout_sends_rst_stream"
    "test_async_stream_reset_leaves_the_shared_connection_usable"
    "test_async_stream_setup_retries_failed_connects"
    "test_sync_abandoned_stream_sends_rst_stream"
    "test_sync_completed_stream_does_not_send_rst_stream"
    "test_sync_dropped_connection_redials_for_the_health_probe"
    "test_sync_early_close_propagates_through_logging_interceptor"
    "test_sync_early_close_sends_rst_stream"
    "test_sync_envd_dials_connections_as_streams_fill_them"
    "test_sync_envd_waits_for_a_stream_at_the_connection_cap"
    "test_sync_stream_reset_leaves_the_shared_connection_usable"
    "test_sync_stream_setup_retries_failed_connects"
    "test_sync_stream_surfaces_plain_http_404_with_vendored_code"
  ];

  # Import e2b from $out rather than the source tree.
  preCheck = ''
    rm -r e2b
  '';

  # The offline tests exercise the transport against an in-process server.
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Cloud environments for AI agents";
    homepage = "https://github.com/e2b-dev/E2B/blob/main/packages/python-sdk";
    changelog = "https://github.com/e2b-dev/E2B/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      GaetanLepage
      mishushakov
    ];
  };
})
