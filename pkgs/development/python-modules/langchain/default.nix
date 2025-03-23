{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  nix-update-script,

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
}:

buildPythonPackage rec {
  pname = "langchain";
  version = "0.3.20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain==${version}";
    hash = "sha256-N209wUGdlHkOZynhSSE+ZHylL7cK+8H3PfZIG/wvMd0=";
  };

  sourceRoot = "${src.name}/libs/langchain";

  patches = [
    # blockbuster isn't supported in nixpkgs
    ./rm-blockbuster.patch
  ];

  build-system = [ pdm-backend ];

  buildInputs = [ bash ];

  pythonRelaxDeps = [
    # Each component release requests the exact latest core.
    # That prevents us from updating individul components.
    "langchain-core"
    "numpy"
    "tenacity"
  ];

  pythonRemoveDeps = [
    "blockbuster"
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
  ] ++ lib.optional (pythonOlder "3.11") async-timeout;

  optional-dependencies = {
    numpy = [ numpy ];
  };

  nativeCheckInputs = [
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

  pytestFlagsArray = [
    # integration_tests require network access, database access and require `OPENAI_API_KEY`, etc.
    "tests/unit_tests"
    "--only-core"
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

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^langchain==([0-9.]+)$"
    ];
  };

  meta = {
    description = "Building applications with LLMs through composability";
    homepage = "https://github.com/langchain-ai/langchain";
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      sarahec
    ];
    mainProgram = "langchain-server";
  };
}
