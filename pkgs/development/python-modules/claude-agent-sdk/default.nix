{
  lib,
  anyio,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  mcp,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  sniffio,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "claude-agent-sdk";
  version = "0.2.152";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anthropics";
    repo = "claude-agent-sdk-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h3LjBolK1hpcATNX45ftYZBTKWQtSF34o78E6fRab2M=";
  };

  build-system = [ hatchling ];

  dependencies = [
    anyio
    mcp
    sniffio
    typing-extensions
  ];

  nativeCheckInputs = [
    anyio
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
  ]
  ++ anyio.passthru.optional-dependencies.trio;

  pythonImportsCheck = [ "claude_agent_sdk" ];

  disabledTests = [
    # Code not available
    "test_query_with_async_iterable"
  ];

  disabledTestPaths = [
    # Tests require claude code with is non-free
    "tests/test_close_cancellation.py"
  ];

  meta = {
    description = "Python SDK for Claude Agent";
    homepage = "https://github.com/anthropics/claude-agent-sdk-python";
    changelog = "https://github.com/anthropics/claude-agent-sdk-python/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
