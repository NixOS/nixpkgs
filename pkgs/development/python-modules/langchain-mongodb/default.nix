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
  version = "0.1.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    rev = "refs/tags/langchain-mongodb==${version}";
    hash = "sha256-p/cdWFPc2Oi5aRmjj1oAixM6aDKw0TbyzMdP4h2acG4=";
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

  passthru = {
    updateScript = langchain-core.updateScript;
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/langchain-mongodb==${version}";
    description = "Integration package connecting MongoDB and LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/mongodb";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
