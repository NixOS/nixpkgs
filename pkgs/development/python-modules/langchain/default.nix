{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  pdm-backend,

  # buildInputs
  bash,

  # dependencies
  aiohttp,
  async-timeout,
  langchain-core,
  langchain-text-splitters,
  langsmith,
  numpy,
  pydantic,
  pyyaml,
  requests,
  sqlalchemy,
  tenacity,

  # tests
  blockbuster,
  freezegun,
  httpx,
  lark,
  pandas,
  pytest-asyncio,
  pytest-mock,
  pytest-socket,
  pytestCheckHook,
  requests-mock,
  responses,
  syrupy,
  toml,

  # passthru
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "langchain";
  version = "0.3.72";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-core==${version}";
    hash = "sha256-Q2uGMiODUtwkPdOyuSqp8vqjlLjiXk75QjXp7rr20tc=";
  };

  sourceRoot = "${src.name}/libs/langchain";

  build-system = [ pdm-backend ];

  buildInputs = [ bash ];

  pythonRelaxDeps = [
    # Each component release requests the exact latest core.
    # That prevents us from updating individual components.
    "langchain-core"
    "numpy"
    "tenacity"
  ];

  dependencies = [
    aiohttp
    langchain-core
    langchain-text-splitters
    langsmith
    numpy
    pydantic
    pyyaml
    requests
    sqlalchemy
    tenacity
  ]
  ++ lib.optional (pythonOlder "3.11") async-timeout;

  optional-dependencies = {
    numpy = [ numpy ];
  };

  nativeCheckInputs = [
    blockbuster
    freezegun
    httpx
    lark
    pandas
    pytest-asyncio
    pytest-mock
    pytest-socket
    pytestCheckHook
    requests-mock
    responses
    syrupy
    toml
  ];

  pytestFlags = [
    "--only-core"
  ];

  enabledTestPaths = [
    # integration_tests require network access, database access and require `OPENAI_API_KEY`, etc.
    "tests/unit_tests"
  ];

  disabledTests = [
    # These tests have database access
    "test_table_info"
    "test_sql_database_run"
    # These tests have network access
    "test_socket_disabled"
    "test_openai_agent_with_streaming"
    "test_openai_agent_tools_agent"
    # This test may require a specific version of langchain-community
    "test_compatible_vectorstore_documentation"
    # AssertionErrors
    "test_callback_handlers"
    "test_generic_fake_chat_model"
    # Test is outdated
    "test_serializable_mapping"
    "test_person"
    "test_aliases_hidden"
    # AssertionError: (failed string match due to terminal control chars in output)
    # https://github.com/langchain-ai/langchain/issues/32150
    "test_filecallback"
  ];

  disabledTestPaths = [
    # pydantic.errors.PydanticUserError: `ConversationSummaryMemory` is not fully defined; you should define `BaseCache`, then call `ConversationSummaryMemory.model_rebuild()`.
    "tests/unit_tests/chains/test_conversation.py"
    # pydantic.errors.PydanticUserError: `ConversationSummaryMemory` is not fully defined; you should define `BaseCache`, then call `ConversationSummaryMemory.model_rebuild()`.
    "tests/unit_tests/chains/test_memory.py"
    # pydantic.errors.PydanticUserError: `ConversationSummaryBufferMemory` is not fully defined; you should define `BaseCache`, then call `ConversationSummaryBufferMemory.model_rebuild()`.
    "tests/unit_tests/chains/test_summary_buffer_memory.py"
    "tests/unit_tests/output_parsers/test_fix.py"
    "tests/unit_tests/chains/test_llm_checker.py"
    # TypeError: Can't instantiate abstract class RunnableSerializable[RetryOutputParserRetryChainInput, str] without an implementation for abstract method 'invoke'
    "tests/unit_tests/output_parsers/test_retry.py"
    # pydantic.errors.PydanticUserError: `LLMSummarizationCheckerChain` is not fully defined; you should define `BaseCache`, then call `LLMSummarizationCheckerChain.model_rebuild()`.
    "tests/unit_tests/chains/test_llm_summarization_checker.py"
  ];

  pythonImportsCheck = [ "langchain" ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "langchain==";
    ignoredVersions = "[0-9]+\.?(a|dev|rc)[0-9]+$";
  };

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Building applications with LLMs through composability";
    homepage = "https://github.com/langchain-ai/langchain";
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      sarahec
    ];
    mainProgram = "langchain-server";
  };
}
