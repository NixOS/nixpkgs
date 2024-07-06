{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  langchain-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "langchain-text-splitters";
  version = "0.2.9";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    rev = "refs/tags/langchain-core==${version}";
    hash = "sha256-/BUn/NxaE9l3VY6dPshr1JJaHTGzn9NMQhSQ2De65Jg=";
  };

  sourceRoot = "${src.name}/libs/text-splitters";

  build-system = [ poetry-core ];

  dependencies = [ langchain-core ];

  pythonImportsCheck = [ "langchain_text_splitters" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests/unit_tests" ];

  passthru = {
    inherit (langchain-core) updateScript;
  };

  meta = {
    description = "Build context-aware reasoning applications";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/text-splitters";
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
