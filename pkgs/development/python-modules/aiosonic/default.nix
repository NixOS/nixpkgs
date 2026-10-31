{
  lib,
  stdenv,
  aiodns,
  buildPythonPackage,
  charset-normalizer,
  fetchFromGitHub,
  h2,
  onecache,
  pkgs,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-mock,
  pytest-timeout,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiosonic";
  version = "1.3.2";
  pyproject = true;

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "sonic182";
    repo = "aiosonic";
    tag = finalAttrs.version;
    hash = "sha256-nCCQBcbIWQ+FAKLXX6IRuFWGjQUXuSqzwGN2A9jfVdw=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [ "h2" ];

  dependencies = [
    charset-normalizer
    h2
    onecache
  ];

  nativeCheckInputs = [
    aiodns
    pkgs.nodejs
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiosonic" ];

  disabledTests = [
    # need a proxy-py server, which does not start in the sandbox
    "test_proxy_request"
    "test_proxy_url_credentials"
    "test_trust_env_proxy"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    # getaddrinfo with AI_ADDRCONFIG fails for every host, even 127.0.0.1, when only
    # loopback is up, https://github.com/sonic182/aiosonic/issues/644
    "test_keepalive_reuse_respects_connection_lifecycle"
    "test_max_conn_idle_ms"
  ];

  disabledTestPaths = [
    # needs the ws npm package, and the rest hit issue 644
    "tests/test_aiosonic_ws.py"
    # tests hang
    "tests/test_sse.py"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    # https://github.com/sonic182/aiosonic/issues/644
    "tests/test_aiosonic.py"
    "tests/test_base_client.py"
    "tests/test_http2.py"
    "tests/test_httpx_client.py"
    "tests/test_multipart.py"
    "tests/test_request_wire.py"
  ];

  meta = {
    description = "Python asyncio http client";
    homepage = "https://github.com/sonic182/aiosonic";
    changelog = "https://github.com/sonic182/aiosonic/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      geraldog
      sonic182
    ];
  };
})
