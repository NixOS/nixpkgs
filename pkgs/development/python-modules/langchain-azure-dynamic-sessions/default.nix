{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  azure-identity,
  langchain-core,
  langchain-openai,

  # tests
  freezegun,
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
  pname = "langchain-azure-dynamic-sessions";
  version = "0.3.30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-core==${version}";
    hash = "sha256-108DlyLAmL7CxEkYWol5wybylpvklFeGaGjGBcbRWg4=";
  };

  sourceRoot = "${src.name}/libs/partners/azure-dynamic-sessions";

  build-system = [ poetry-core ];

  dependencies = [
    azure-identity
    langchain-core
    langchain-openai
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

  pythonImportsCheck = [ "langchain_azure_dynamic_sessions" ];

  passthru = {
    inherit (langchain-core) updateScript;
  };

  meta = {
    description = "Integration package connecting Azure Container Apps dynamic sessions and LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/azure-dynamic-sessions";
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/langchain-azure-dynamic-sessions==${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      sarahec
    ];
  };
}
