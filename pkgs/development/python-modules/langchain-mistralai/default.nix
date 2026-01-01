{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  langchain-core,
  tokenizers,
  httpx,
  httpx-sse,
  pydantic,

  # tests
  langchain-tests,
  pytest-asyncio,
  pytestCheckHook,

  # passthru
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "langchain-mistralai";
<<<<<<< HEAD
  version = "1.1.1";
=======
  version = "1.0.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-mistralai==${version}";
<<<<<<< HEAD
    hash = "sha256-cdUl6LusttH6c0tBvaxQR5UGHjwyubKELCDv61VQ6Qo=";
=======
    hash = "sha256-o9xIIcqsuTgWMeluk3EMY3hbB3wGjhYYfzbHizpNTo8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  sourceRoot = "${src.name}/libs/partners/mistralai";

  build-system = [ hatchling ];

  dependencies = [
    langchain-core
    tokenizers
    httpx
    httpx-sse
    pydantic
  ];

  nativeCheckInputs = [
    langchain-tests
    pytest-asyncio
    pytestCheckHook
  ];

  enabledTestPaths = [ "tests/unit_tests" ];

  disabledTests = [
    # Comparison error due to message formatting differences
    "test__convert_dict_to_message_tool_call"
<<<<<<< HEAD
    # Fails when langchain-core gets ahead of this package
    "test_serdes"
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  pythonImportsCheck = [ "langchain_mistralai" ];

  passthru = {
    # python updater script sets the wrong tag
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "langchain-mistralai==";
    };
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/${src.tag}";
    description = "Build LangChain applications with mistralai";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/mistralai";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.sarahec
    ];
  };
}
