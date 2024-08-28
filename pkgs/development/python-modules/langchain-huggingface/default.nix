{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  huggingface-hub,
  langchain-core,
  sentence-transformers,
  tokenizers,
  transformers,
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
  pname = "langchain-huggingface";
  version = "0.2.35";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    rev = "refs/tags/langchain-core==${version}";
    hash = "sha256-IZxMiJA2a7cfc+w7miUnOaCCn4FudG4CNlAIRDBmkfk=";
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

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/langchain-huggingface==${version}";
    description = "An integration package connecting Huggingface related classes and LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/huggingface";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
