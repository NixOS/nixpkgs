{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  filetype,
  google-api-core,
  google-auth,
  google-genai,
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
  version = "4.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain-google";
    tag = "libs/genai/v${version}";
    hash = "sha256-1WL5pasYHKzXRbOGo910SP3YP6eg00aFoOd7RTwV++A=";
  };

  sourceRoot = "${src.name}/libs/genai";

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    # Each component release requests the exact latest core.
    # That prevents us from updating individual components.
    "langchain-core"
  ];

  dependencies = [
    filetype
    google-api-core
    google-auth
    google-genai
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

  enabledTestPaths = [ "tests/unit_tests" ];

  disabledTests = [
    # Fails when langchain-core gets ahead of this package
    "test_serdes"
    "test_serialize"
  ];

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
