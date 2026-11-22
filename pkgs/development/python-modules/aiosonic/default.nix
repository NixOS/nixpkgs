{
  lib,
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
  version = "1.4.1";
  pyproject = true;

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "sonic182";
    repo = "aiosonic";
    tag = finalAttrs.version;
    hash = "sha256-K1FgfQ1yKAAE9EZIqb1cAL/7P6bl37IJlblaG50FKzY=";
  };

  build-system = [ poetry-core ];

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
  ];

  disabledTestPaths = [
    # needs the ws npm package
    "tests/test_aiosonic_ws.py"
    # tests hang
    "tests/test_sse.py"
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
