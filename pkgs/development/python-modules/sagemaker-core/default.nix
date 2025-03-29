{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  boto3,
  importlib-metadata,
  jsonschema,
  mock,
  platformdirs,
  pydantic,
  pyyaml,
  rich,

  # optional-dependencies
  black,
  pandas,
  pylint,
  pytest,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sagemaker-core";
  version = "1.0.25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "sagemaker-core";
    tag = "v${version}";
    hash = "sha256-VfqQJf0r11z+GT/jpcVBdP2nLWf1lsjvijb1IsbOILQ=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "boto3"
    "importlib-metadata"
    "mock"
  ];

  dependencies = [
    boto3
    importlib-metadata
    jsonschema
    mock
    platformdirs
    pydantic
    pyyaml
    rich
  ];

  optional-dependencies = {
    codegen = [
      black
      pandas
      pylint
      pytest
    ];
  };

  pythonImportsCheck = [
    "sagemaker_core"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  disabledTestPaths = [
    # Tries to import deprecated `sklearn`
    "integ/test_codegen.py"

    # botocore.exceptions.NoRegionError: You must specify a region
    "tst/generated/test_logs.py"
  ];

  meta = {
    description = "Python object-oriented interface for interacting with Amazon SageMaker resources";
    homepage = "https://github.com/aws/sagemaker-core";
    changelog = "https://github.com/aws/sagemaker-core/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
