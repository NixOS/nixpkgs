{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  boto3,
  langchain-core,
  numpy,
  pydantic,

  # optional-dependencies
  langchain-anthropic,
  anthropic,

  # tests
  langchain-tests,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,

  # passthru
  gitUpdater,
}:

buildPythonPackage (finalAttrs: {
  pname = "langchain-aws";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain-aws";
    tag = "langchain-aws==${finalAttrs.version}";
    hash = "sha256-hKMTzN2NVMSMCVsFroFFUM0embz8KHbDnmunwOb9ofw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--snapshot-warn-unused" ""
  '';

  sourceRoot = "${finalAttrs.src.name}/libs/aws";

  build-system = [ hatchling ];

  dependencies = [
    boto3
    langchain-core
    numpy
    pydantic
  ];

  pythonRelaxDeps = [
    # Boto3 spec has outstripped the version requirement
    "boto3"
  ];

  optional-dependencies = {
    anthropic = [
      anthropic.optional-dependencies.bedrock
      langchain-anthropic
    ];
  };

  nativeCheckInputs = [
    anthropic
    langchain-tests
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  enabledTestPaths = [ "tests/unit_tests" ];

  disabledTests = [
    # Fails when langchain-core gets ahead of this package
    "test_serdes"
  ];

  pythonImportsCheck = [ "langchain_aws" ];

  passthru = {
    # python updater script sets the wrong tag
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "langchain-aws==";
    };
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain-aws/releases/tag/${finalAttrs.src.tag}";
    description = "Build LangChain application on AWS";
    homepage = "https://github.com/langchain-ai/langchain-aws/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      sarahec
    ];
  };
})
