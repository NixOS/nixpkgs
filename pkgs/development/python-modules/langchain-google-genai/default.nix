{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pdm-backend,

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
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain-google";
    tag = "libs/genai/v${version}";
    hash = "sha256-9Z0iRSICApA5/iHB7NTVYGpkktaoynG74W2mvn9zeMg=";
  };

  sourceRoot = "${src.name}/libs/genai";

  build-system = [ pdm-backend ];

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
    maintainers = with lib.maintainers; [
      eu90h
      sarahec
    ];
  };
}
