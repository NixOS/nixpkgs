{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pdm-backend,

  # dependencies
  langchain-core,
  openai,
  tiktoken,

  # tests
  freezegun,
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
  version = "0.3.28";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-openai==${version}";
    hash = "sha256-HpAdCHxmfGJcqXArvtlYagNuEBGBjrbICIwh9nI0qMQ=";
  };

  sourceRoot = "${src.name}/libs/partners/openai";

  build-system = [ pdm-backend ];

  pythonRelaxDeps = [
    # Each component release requests the exact latest core.
    # That prevents us from updating individual components.
    "langchain-core"
  ];

  dependencies = [
    langchain-core
    openai
    tiktoken
  ];

  nativeCheckInputs = [
    freezegun
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
    "test__convert_dict_to_message_tool_call"
    "test__get_encoding_model"
    "test_azure_openai_api_key_is_secret_string"
    "test_azure_openai_api_key_masked_when_passed_from_env"
    "test_azure_openai_api_key_masked_when_passed_via_constructor"
    "test_azure_openai_secrets"
    "test_azure_openai_uses_actual_secret_value_from_secretstr"
    "test_azure_serialized_secrets"
    "test_chat_openai_get_num_tokens"
    "test_embed_documents_with_custom_chunk_size"
    "test_get_num_tokens_from_messages"
    "test_get_token_ids"
    "test_init_o1"
    "test_openai_get_num_tokens"
  ];

  disabledTestPaths = [
    # TODO recheck on next update. Langchain has been working on Pydantic errors.
    # ValidationError from pydantic
    "tests/unit_tests/chat_models/test_responses_stream.py"
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
