{
  lib,
  buildPythonPackage,

  # build-system
  poetry-core,

  # dependencies
  httpx,
  langchain-core,
  syrupy,

  # buildInputs
  pytest,

  # tests
  numpy,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "langchain-standard-tests";
  pyproject = true;

  # this is an internal library, so there are no tags
  # sync source with langchain-core for easy updates
  inherit (langchain-core) src version;
  sourceRoot = "${src.name}/libs/standard-tests";

  build-system = [ poetry-core ];

  dependencies = [
    httpx
    langchain-core
    syrupy
  ];

  buildInputs = [ pytest ];

  pythonImportsCheck = [ "langchain_standard_tests" ];

  nativeBuildInputs = [
    numpy
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    description = "Build context-aware reasoning applications";
    homepage = "https://github.com/langchain-ai/langchain";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      sarahec
    ];
  };
}
