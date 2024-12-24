{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  langchain-core,
  openai,
  tiktoken,

  # tests
  freezegun,
  langchain-standard-tests,
  lark,
  pandas,
  pytest-asyncio,
  pytestCheckHook,
  pytest-mock,
  pytest-socket,
  requests-mock,
  responses,
  syrupy,
  toml,
}:

buildPythonPackage rec {
  pname = "langchain-openai";
  version = "0.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    rev = "refs/tags/langchain-openai==${version}";
    hash = "sha256-Gm7MAOuG+kYQ3TRTRdQXJ+HcoUz+iL9j+pTXz+zAySg=";
  };

  sourceRoot = "${src.name}/libs/partners/openai";

  preConfigure = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--cov=langchain_openai" ""
  '';

  build-system = [ poetry-core ];

  dependencies = [
    langchain-core
    openai
    tiktoken
  ];

  nativeCheckInputs = [
    freezegun
    langchain-standard-tests
    lark
    pandas
    pytest-asyncio
    pytestCheckHook
    pytest-mock
    pytest-socket
    requests-mock
    responses
    syrupy
    toml
  ];

  pytestFlagsArray = [ "tests/unit_tests" ];

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
    "test_get_num_tokens_from_messages"
    "test_get_token_ids"
    "test_openai_get_num_tokens"
  ];

  pythonImportsCheck = [ "langchain_openai" ];

  passthru = {
    inherit (langchain-core) updateScript;
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/langchain-openai==${version}";
    description = "Integration package connecting OpenAI and LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/openai";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      sarahec
    ];
  };
}
