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

buildPythonPackage rec {
  pname = "langchain-openai";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-openai==${version}";
    hash = "sha256-dmuDgKQW1yAz/8tjQx7LaUiuz5Sh4cAyd9nt33mCPbI=";
  };

  sourceRoot = "${src.name}/libs/partners/openai";

  build-system = [ hatchling ];

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
  ];

  pythonImportsCheck = [ "langchain_openai" ];

  passthru = {
    # python updater script sets the wrong tag
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "langchain-openai==";
    };
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/${src.tag}";
    description = "Integration package connecting OpenAI and LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/openai";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      sarahec
    ];
  };
}
