{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  langchain,
  langchain-core,
  openai,
  tiktoken,
  lark,
  pandas,
  poetry-core,
  pytest-asyncio,
  pytest-mock,
  pytest-socket,
  pytestCheckHook,
  pythonOlder,
  requests-mock,
  responses,
  syrupy,
  toml,
}:

buildPythonPackage rec {
  pname = "langchain-openai";
  version = "0.1.17";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    rev = "refs/tags/langchain-openai==${version}";
    hash = "sha256-ELD1KXCVx3SmiJodagtOHgBGKdjRWiRVCCNYcL63eCY=";
  };

  sourceRoot = "${src.name}/libs/partners/openai";

  preConfigure = ''
    ln -s ${src}/libs/standard-tests/langchain_standard_tests ./langchain_standard_tests

    substituteInPlace pyproject.toml \
      --replace-fail "path = \"../../standard-tests\"" "path = \"./langchain_standard_tests\"" \
      --replace-fail "--cov=langchain_openai" ""
  '';

  build-system = [ poetry-core ];

  dependencies = [
    langchain
    langchain-core
    openai
    tiktoken
  ];

  nativeCheckInputs = [
    freezegun
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

  pytestFlagsArray = [ "tests/unit_tests" ];

  disabledTests = [
    # These tests require network access
    "test__get_encoding_model"
    "test_get_token_ids"
    "test_azure_openai_secrets"
    "test_azure_openai_api_key_is_secret_string"
    "test_get_num_tokens_from_messages"
    "test_azure_openai_api_key_masked_when_passed_from_env"
    "test_azure_openai_api_key_masked_when_passed_via_constructor"
    "test_azure_openai_uses_actual_secret_value_from_secretstr"
    "test_azure_serialized_secrets"
    "test_openai_get_num_tokens"
    "test_chat_openai_get_num_tokens"
  ];

  pythonImportsCheck = [ "langchain_openai" ];

  passthru = {
    updateScript = langchain-core.updateScript;
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/langchain-openai==${version}";
    description = "Integration package connecting OpenAI and LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/openai";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
