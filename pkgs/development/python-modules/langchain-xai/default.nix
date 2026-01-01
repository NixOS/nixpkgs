{
  lib,
  stdenvNoCC,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  aiohttp,
  langchain-core,
  langchain-openai,
  requests,

  # tests
  langchain-tests,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,

  # passthru
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "langchain-xai";
<<<<<<< HEAD
  version = "1.1.0";
=======
  version = "1.0.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-xai==${version}";
<<<<<<< HEAD
    hash = "sha256-bm7sIa62CIvsYNDdaN+XZKpRnCv5bg9kPZ1Ym8utFcM=";
=======
    hash = "sha256-engdUNTT3KsAGrJ93PiFQoI6jbBFPAqavDsrD073484=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  sourceRoot = "${src.name}/libs/partners/xai";

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    langchain-core
    langchain-openai
    requests
  ];

  pythonRelaxDeps = [
    # Each component release requests the exact latest core.
    # That prevents us from updating individual components.
    "langchain-core"
  ];

  nativeCheckInputs = [
    langchain-tests
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  enabledTestPaths = [ "tests/unit_tests" ];

<<<<<<< HEAD
  disabledTests = [
    # Breaks when langchain-core is updated
    # Also: Compares a diff to a string literal and misses platform differences (aarch64-linux)
    "test_serdes"
  ];
=======
  disabledTests =
    lib.optionals (stdenvNoCC.hostPlatform.isLinux && stdenvNoCC.hostPlatform.isAarch64)
      [
        # Compares a diff to a string literal and misses platform differences
        "test_serdes"
      ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  pythonImportsCheck = [ "langchain_xai" ];

  passthru = {
    # python updater script sets the wrong tag
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "langchain-xai==";
    };
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain-xai/releases/tag/${src.tag}";
    description = "Build LangChain applications with X AI";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/xai";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.sarahec
    ];
  };
}
