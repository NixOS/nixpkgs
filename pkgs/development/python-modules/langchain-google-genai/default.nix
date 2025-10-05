{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  filetype,
  google-api-core,
  google-auth,
  google-generativeai,
  langchain-core,
  pydantic,

  # tests
  freezegun,
  langchain-tests,
  numpy,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  syrupy,

  # passthru
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "langchain-google-genai";
  version = "2.1.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain-google";
    tag = "libs/genai/v${version}";
    hash = "sha256-kqII8RG1ep+n5CqKLY1v7Mc+zJh6kl1rAjMmkomfeqM=";
  };

  sourceRoot = "${src.name}/libs/genai";

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    # Each component release requests the exact latest core.
    # That prevents us from updating individual components.
    "langchain-core"
  ];

  dependencies = [
    filetype
    google-api-core
    google-auth
    google-generativeai
    langchain-core
    pydantic
  ];

  nativeCheckInputs = [
    freezegun
    langchain-tests
    numpy
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    syrupy
  ];

  pytestFlagsArray = [ "tests/unit_tests" ];

  pythonImportsCheck = [ "langchain_google_genai" ];

  passthru = {
    # python updater script sets the wrong tag
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "libs/genai/v";
    };
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain-google/releases/tag/${src.tag}";
    description = "LangChain integrations for Google Gemini";
    homepage = "https://github.com/langchain-ai/langchain-google/tree/main/libs/genai";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.eu90h
      lib.maintainers.sarahec
    ];
  };
}
