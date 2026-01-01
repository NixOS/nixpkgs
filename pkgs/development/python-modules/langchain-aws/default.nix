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
<<<<<<< HEAD
  version = "1.1.1";
=======
  version = "1.0.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain-aws";
    tag = "langchain-aws==${version}";
<<<<<<< HEAD
    hash = "sha256-tFyVK7IjPy33Az16DhWO6wSL5hBAdyd+urhSvdb18Ww=";
=======
    hash = "sha256-Y4r9a7EiyOACcU41+1Lo89jguu1QmijWsNeoNqKF3cY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--snapshot-warn-unused" ""
  '';

  sourceRoot = "${src.name}/libs/aws";

<<<<<<< HEAD
  build-system = [ hatchling ];
=======
  build-system = [ pdm-backend ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  disabledTests = [
    # Fails when langchain-core gets ahead of this package
    "test_serdes"
  ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pythonImportsCheck = [ "langchain_aws" ];

  passthru = {
    # python updater script sets the wrong tag
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "langchain-aws==";
    };
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain-aws/releases/tag/${src.tag}";
    description = "Build LangChain application on AWS";
    homepage = "https://github.com/langchain-ai/langchain-aws/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      sarahec
    ];
  };
}
