{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,

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
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-azure-dynamic-sessions==${version}";
    hash = "sha256-ACR+JzKcnYXROGOQe6DlZeqcYd40KlesgXSUOybOT20=";
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

  pytestFlagsArray = [ "tests/unit_tests" ];

  pythonImportsCheck = [ "langchain_azure_dynamic_sessions" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^langchain-azure-dynamic-sessions==([0-9.]+)$"
    ];
  };

  meta = {
    description = "Integration package connecting Azure Container Apps dynamic sessions and LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/azure-dynamic-sessions";
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/langchain-azure-dynamic-sessions==${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      sarahec
    ];
  };
}
