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

buildPythonPackage (finalAttrs: {
  pname = "langchain-google-genai";
  version = "4.2.5";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain-google";
    tag = "libs/genai/v${finalAttrs.version}";
    hash = "sha256-NgP3KyhFprlUoZUg69ZVqTwG9IW6nvX3k6VYz69LdrU=";
  };

  sourceRoot = "${finalAttrs.src.name}/libs/genai";

  build-system = [ hatchling ];

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
    # pydantic_core._pydantic_core.ValidationError: 1 validation error for GenerateContentResponse
    # extra inputs are not permitted
    "test_grounding_metadata_to_citations_conversion"
  ];

  disabledTestPaths = [
    # AssertionError: assert {'google_maps...s': None, ...} == {'google_maps...a'...
    # https://github.com/langchain-ai/langchain-google/issues/1791
    "tests/unit_tests/test_chat_models.py::test_response_to_result_grounding_metadata"
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
    changelog = "https://github.com/langchain-ai/langchain-google/releases/tag/${finalAttrs.src.tag}";
    description = "LangChain integrations for Google Gemini";
    homepage = "https://github.com/langchain-ai/langchain-google/tree/main/libs/genai";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      eu90h
      sarahec
    ];
  };
})
