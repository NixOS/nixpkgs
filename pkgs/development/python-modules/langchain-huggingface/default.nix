{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  huggingface-hub,
  langchain-core,
  sentence-transformers,
  tokenizers,
  transformers,

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
  pname = "langchain-huggingface";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    rev = "refs/tags/langchain-huggingface==${version}";
    hash = "sha256-ESWhhjWjCbBV/3KjeSwEQzvK6os1mmc3at+8gonfGt4=";
  };

  sourceRoot = "${src.name}/libs/partners/huggingface";

  build-system = [ poetry-core ];

  dependencies = [
    huggingface-hub
    langchain-core
    sentence-transformers
    tokenizers
    transformers
  ];

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

  pytestFlagsArray = [ "tests/unit_tests" ];

  pythonImportsCheck = [ "langchain_huggingface" ];

  passthru = {
    inherit (langchain-core) updateScript;
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/langchain-huggingface==${version}";
    description = "An integration package connecting Huggingface related classes and LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/huggingface";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
