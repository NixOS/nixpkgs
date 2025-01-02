{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  langchain-core,
  numpy,
  pymongo,

  freezegun,
  httpx,
  langchain,
  pytest-asyncio,
  pytestCheckHook,
  pytest-mock,
  syrupy,
}:

buildPythonPackage rec {
  pname = "langchain-mongodb";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    rev = "refs/tags/langchain-mongodb==${version}";
    hash = "sha256-Jd9toXkS9dGtSIrJQ/5W+swV1z2BJOJKBtkyGzj3oSc=";
  };

  sourceRoot = "${src.name}/libs/partners/mongodb";

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    "numpy"
  ];

  dependencies = [
    langchain-core
    numpy
    pymongo
  ];

  nativeCheckInputs = [
    freezegun
    httpx
    langchain
    pytest-asyncio
    pytestCheckHook
    pytest-mock
    syrupy
  ];

  pytestFlagsArray = [ "tests/unit_tests" ];

  pythonImportsCheck = [ "langchain_mongodb" ];

  passthru = {
    inherit (langchain-core) updateScript;
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/langchain-mongodb==${version}";
    description = "Integration package connecting MongoDB and LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/mongodb";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      sarahec
    ];
  };
}
