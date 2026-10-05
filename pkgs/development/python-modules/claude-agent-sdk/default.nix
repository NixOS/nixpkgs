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
  version = "0.2.163";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anthropics";
    repo = "claude-agent-sdk-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QG6y0/VGhyqBMiBarGfHxwF61qieDhzveQtA3cNWPok=";
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
    # Tests require claude code with is non-free
    "test_ceiling_closes_stdin_when_idle_never_comes"
    "test_caller_who_opted_in_sees_the_frames"
    "test_follow_up_turn_is_served_and_sdk_frames_stay_hidden"
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
