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

  nix-update-script,
}:

buildPythonPackage rec {
  pname = "langchain-azure-dynamic-sessions";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    rev = "refs/tags/langchain-azure-dynamic-sessions==${version}";
    hash = "sha256-tgvoOSr4tpi+tFBan+kw8FZUfUJHcQXv9e1nyeGP0so=";
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

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "langchain-azure-dynamic-sessions==(.*)"
    ];
  };

  meta = {
    description = "Integration package connecting Azure Container Apps dynamic sessions and LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/azure-dynamic-sessions";
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/langchain-azure-dynamic-sessions==${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
