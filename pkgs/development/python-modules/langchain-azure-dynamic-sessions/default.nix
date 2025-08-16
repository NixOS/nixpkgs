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

  # passthru
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "langchain-azure-dynamic-sessions";
  version = "0.3.72";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-core==${version}";
    hash = "sha256-Q2uGMiODUtwkPdOyuSqp8vqjlLjiXk75QjXp7rr20tc=";
  };

  sourceRoot = "${src.name}/libs/partners/azure-dynamic-sessions";

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    # Each component release requests the exact latest core.
    # That prevents us from updating individual components.
    "langchain-core"
  ];

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

  enabledTestPaths = [ "tests/unit_tests" ];

  pythonImportsCheck = [ "langchain_azure_dynamic_sessions" ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "langchain-azure-dynamic-sessions==";
  };

  meta = {
    description = "Integration package connecting Azure Container Apps dynamic sessions and LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/azure-dynamic-sessions";
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      sarahec
    ];
  };
}
