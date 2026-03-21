{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  langchain-core,
  langgraph,
  pydantic,

  # Optional dependencies
  langchain-anthropic,
  langchain-aws,
  langchain-community,
  langchain-deepseek,
  langchain-fireworks,
  langchain-google-genai,
  langchain-groq,
  langchain-huggingface,
  langchain-mistralai,
  langchain-ollama,
  langchain-openai,
  langchain-perplexity,
  langchain-xai,

  # runtime
  runtimeShell,

  # tests
  blockbuster,
  langchain-tests,
  pytest-asyncio,
  pytest-mock,
  pytest-socket,
  pytest-xdist,
  pytestCheckHook,
  syrupy,
  toml,

  # passthru
  gitUpdater,
}:

buildPythonPackage (finalAttrs: {
  pname = "langchain";
  version = "1.2.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain==${finalAttrs.version}";
    hash = "sha256-Z0noVsSu0OZchynlJSkIe0p076/0nay+1uS2ZXnztns=";
  };

  sourceRoot = "${finalAttrs.src.name}/libs/langchain_v1";

  postPatch = ''
    substituteInPlace langchain/agents/middleware/shell_tool.py \
      --replace-fail '"/bin/bash"' '"${runtimeShell}"'
  '';

  build-system = [ hatchling ];

  dependencies = [
    langchain-core
    langgraph
    pydantic
  ];

  optional-dependencies = {
    anthropic = [ langchain-anthropic ];
    aws = [ langchain-aws ];
    # azure-ai = [langchain-azure-ai];
    community = [ langchain-community ];
    deepseek = [ langchain-deepseek ];
    fireworks = [ langchain-fireworks ];
    google-genai = [ langchain-google-genai ];
    # google-vertexai = [langchain-google-vertexai];
    groq = [ langchain-groq ];
    huggingface = [ langchain-huggingface ];
    mistralai = [ langchain-mistralai ];
    ollama = [ langchain-ollama ];
    openai = [ langchain-openai ];
    perplexity = [ langchain-perplexity ];
    # together = [langchain-together];
    xai = [ langchain-xai ];
  };

  nativeCheckInputs = [
    blockbuster
    langchain-tests
    # langchain-openai -- causes recursion error
    pytest-asyncio
    pytest-mock
    pytest-socket
    pytest-xdist
    pytestCheckHook
    syrupy
    toml
  ];

  pytestFlags = [
    "--only-core"
  ];

  # Note: Not testing with optional dependencies due to mutual recursion
  enabledTestPaths = [
    # integration_tests require network access, database access and require `OPENAI_API_KEY`, etc.
    "tests/unit_tests"
  ];

  # All pass with sandbox=false
  disabledTests = [
    # Depends on shell's truncation style
    "test_truncation_indicator_present"
    # Depends on the sleep shell command
    "test_timeout_returns_error"
    # Can't see the shell session results when sandboxed
    "test_startup_and_shutdown_commands"
    # Timing sensitive tests
    "test_tool_retry_constant_backoff"
  ];

  disabledTestPaths = [
    # Their configuration tests don't place nicely with nixpkgs
    "tests/unit_tests/test_pytest_config.py"
  ];

  pythonImportsCheck = [ "langchain" ];

  passthru = {
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "langchain==";
    };
  };

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Building applications with LLMs through composability";
    homepage = "https://github.com/langchain-ai/langchain";
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      sarahec
    ];
  };
})
