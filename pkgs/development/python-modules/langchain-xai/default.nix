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
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-xai==${version}";
    hash = "sha256-engdUNTT3KsAGrJ93PiFQoI6jbBFPAqavDsrD073484=";
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

  disabledTests =
    lib.optionals (stdenvNoCC.hostPlatform.isLinux && stdenvNoCC.hostPlatform.isAarch64)
      [
        # Compares a diff to a string literal and misses platform differences
        "test_serdes"
      ];

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
