{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  httpx,
  langchain-core,
  numpy,
  pytest-asyncio,
  pytest-recording,
  pytest-socket,
  syrupy,
  vcrpy,

  # buildInputs
  pytestCheckHook,

  # tests
  pytest-benchmark,

  # passthru
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "langchain-tests";
  version = "1.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-tests==${version}";
    hash = "sha256-g5s7zL4l/kIUoIu7/3+Ve3SXW3O9tj8f2N3bZ0gbBts=";
  };

  sourceRoot = "${src.name}/libs/standard-tests";

  build-system = [ hatchling ];

  pythonRemoveDeps = [
    "pytest-benchmark"
    "pytest-codspeed"
  ];

  pythonRelaxDeps = [
    "syrupy"
  ];

  dependencies = [
    httpx
    langchain-core
    numpy
    pytest-asyncio
    pytest-benchmark
    pytest-recording
    pytest-socket
    syrupy
    vcrpy
  ];

  pythonImportsCheck = [ "langchain_tests" ];

  nativeBuildInputs = [
    pytestCheckHook
  ];

  disabledTestMarks = [
    "benchmark"
  ];

  passthru = {
    # python updater script sets the wrong tag
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "langchain-tests==";
    };
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/${src.tag}";
    description = "Build context-aware reasoning applications";
    homepage = "https://github.com/langchain-ai/langchain";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      sarahec
    ];
  };
}
