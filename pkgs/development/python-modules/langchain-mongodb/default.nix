{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  langchain,
  langchain-core,
  pymongo,
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
  pname = "langchain-mongodb";
  version = "0.2.35";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    rev = "refs/tags/langchain-core==${version}";
    hash = "sha256-IZxMiJA2a7cfc+w7miUnOaCCn4FudG4CNlAIRDBmkfk=";
  };

  sourceRoot = "${src.name}/libs/partners/mongodb";

  build-system = [ poetry-core ];

  dependencies = [
    langchain-core
    pymongo
  ];

  nativeCheckInputs = [
    freezegun
    langchain
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

  pythonImportsCheck = [ "langchain_mongodb" ];

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/langchain-mongodb==${version}";
    description = "Integration package connecting MongoDB and LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/mongodb";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
