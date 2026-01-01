{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
<<<<<<< HEAD
  hatchling,
=======
  pdm-backend,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # dependencies
  filetype,
  google-api-core,
  google-auth,
<<<<<<< HEAD
  google-genai,
=======
  google-generativeai,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  version = "4.1.1";
=======
  version = "3.0.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain-google";
    tag = "libs/genai/v${version}";
<<<<<<< HEAD
    hash = "sha256-PqJyT6Z6XpDvbexLlrrfeeycS4mXNR3vpWz3vSy+iac=";
=======
    hash = "sha256-9Z0iRSICApA5/iHB7NTVYGpkktaoynG74W2mvn9zeMg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  sourceRoot = "${src.name}/libs/genai";

<<<<<<< HEAD
  build-system = [ hatchling ];
=======
  build-system = [ pdm-backend ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  pythonRelaxDeps = [
    # Each component release requests the exact latest core.
    # That prevents us from updating individual components.
    "langchain-core"
  ];

  dependencies = [
    filetype
    google-api-core
    google-auth
<<<<<<< HEAD
    google-genai
=======
    google-generativeai
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  enabledTestPaths = [ "tests/unit_tests" ];

  disabledTests = [
    # Fails when langchain-core gets ahead of this package
    "test_serdes"
    "test_serialize"
  ];
=======
  pytestFlagsArray = [ "tests/unit_tests" ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
