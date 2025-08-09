{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  boto3,
  langchain-core,
  numpy,
  pydantic,

  # tests
  langchain-tests,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,

  # passthru
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "langchain-aws";
  version = "0.2.30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain-aws";
    tag = "langchain-aws==${version}";
    hash = "sha256-Q69DAqdlddTaUMxw51dLb+CQt5HOsaumlU8mfkGWZkQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--snapshot-warn-unused" ""
  '';

  sourceRoot = "${src.name}/libs/aws";

  build-system = [ poetry-core ];

  dependencies = [
    boto3
    langchain-core
    numpy
    pydantic
  ];

  pythonRelaxDeps = [
    # Boto @ 1.35 has outstripped the version requirement
    "boto3"
    # Each component release requests the exact latest core.
    # That prevents us from updating individual components.
    "langchain-core"
  ];

  nativeCheckInputs = [
    langchain-tests
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  enabledTestPaths = [ "tests/unit_tests" ];

  pythonImportsCheck = [ "langchain_aws" ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "langchain-aws==";
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain-aws/releases/tag/${src.tag}";
    description = "Build LangChain application on AWS";
    homepage = "https://github.com/langchain-ai/langchain-aws/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      drupol
      natsukium
      sarahec
    ];
  };
}
