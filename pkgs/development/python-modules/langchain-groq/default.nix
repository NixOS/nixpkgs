{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  langchain-core,
  groq,

  # tests
  langchain-tests,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "langchain-groq";
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-groq==${version}";
    hash = "sha256-hXY0xmt0rvV/AhMZTR+UxMz0ba7pJjRzBRVn6XvX6cA=";
  };

  sourceRoot = "${src.name}/libs/partners/groq";

  build-system = [ poetry-core ];

  pythonRelaxDeps = [ "langchain-core" ];

  dependencies = [
    langchain-core
    groq
  ];

  nativeCheckInputs = [
    langchain-tests
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests/unit_tests" ];

  pythonImportsCheck = [ "langchain_groq" ];

  passthru = {
    inherit (langchain-core) updateScript;
    skipBulkUpdate = true; # Broken, see https://github.com/NixOS/nixpkgs/issues/379898
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/langchain-groq==${version}";
    description = "Integration package connecting Groq and LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/groq";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sarahec
    ];
  };
}
