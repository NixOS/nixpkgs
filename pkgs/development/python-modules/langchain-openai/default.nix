{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  langchain-core,
  openai,
  tiktoken,

  # tests
  freezegun,
  langchain,
  langchain-tests,
  lark,
  pandas,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pytest-mock,
  pytest-socket,
  requests-mock,
  responses,
  syrupy,
  toml,

  # passthru
  gitUpdater,
}:

buildPythonPackage (finalAttrs: {
  pname = "langchain-openai";
  version = "1.4.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-openai==${finalAttrs.version}";
    hash = "sha256-ELiQJQ8tuQX246ZOr/+iYj/vJRtIX5Cr5PIn4Ul0E8c=";
  };

  sourceRoot = "${finalAttrs.src.name}/libs/partners/openai";

  build-system = [ hatchling ];

  # The python3Packages.openai update has to go through staging, so be open to newer versions
  pythonRelaxDeps = [ "openai" ];

  dependencies = [
    langchain-core
    openai
    tiktoken
  ];

  nativeCheckInputs = [
    freezegun
    langchain
    langchain-tests
    lark
    pandas
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    pytest-mock
    pytest-socket
    requests-mock
    responses
    syrupy
    toml
  ];

  enabledTestPaths = [ "tests/unit_tests" ];

  disabledTests = [
    # These tests require network access
    "test__get_encoding_model"
    "test_chat_openai_get_num_tokens"
    "test_embed_documents_with_custom_chunk_size"
    "test_get_num_tokens_from_messages"
    "test_get_token_ids"
    "test_embeddings_respects_token_limit"

    # Fail when langchain-core gets ahead of this package
    "test_serdes"
    "test_loads_openai_llm"
    "test_load_openai_llm"
    "test_loads_openai_chat"
    "test_load_openai_chat"
    "test_format_message_content"
  ];

  pythonImportsCheck = [ "langchain_openai" ];

  passthru = {
    # python updater script sets the wrong tag
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "langchain-openai==";
      ignoredVersions = "a|b|dev|rc";
    };
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/${finalAttrs.src.tag}";
    description = "Integration package connecting OpenAI and LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/openai";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      sarahec
    ];
  };
})
