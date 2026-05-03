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

buildPythonPackage (finalAttrs: {
  pname = "langchain-tests";
  version = "1.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-tests==${finalAttrs.version}";
    hash = "sha256-W+uJy0t6awNwMpMHEftHV8tDliEhvL/g8V2ZJPWeYk8=";
  };

  sourceRoot = "${finalAttrs.src.name}/libs/standard-tests";

  build-system = [ hatchling ];

  pythonRemoveDeps = [
    "pytest-benchmark"
    "pytest-codspeed"
  ];

  pythonRelaxDeps = [
    "pytest"
    "syrupy"
    "vcrpy"
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
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/${finalAttrs.src.tag}";
    description = "Build context-aware reasoning applications";
    homepage = "https://github.com/langchain-ai/langchain";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      sarahec
    ];
  };
})
