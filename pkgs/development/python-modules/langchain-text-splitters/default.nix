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
  version = "0.2.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    rev = "refs/tags/langchain-text-splitters==${version}";
    hash = "sha256-QrgZ0j/YdOgEgLeQNSKjOIwqdr/Izuw9Gh6eKQ/00tQ=";
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

  meta = with lib; {
    description = "Build context-aware reasoning applications";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/text-splitters";
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
