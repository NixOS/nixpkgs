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
<<<<<<< HEAD
  version = "1.0.72";
=======
  version = "1.0.69";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "sagemaker-core";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-KntbPDsboaDs5jSREQca+N9xUd3lCZzH0pqeCIHmVxw=";
=======
    hash = "sha256-Pkd6x2B0LGKNbDHFSDk8be0VAb9eCyaR6VZcU5A3mCA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "boto3"
    "importlib-metadata"
    "mock"
    "rich"
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
  ]
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;
=======
  ++ lib.flatten (lib.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  disabledTestPaths = [
    # Tries to import deprecated `sklearn`
    "integ/test_codegen.py"

    # botocore.exceptions.NoRegionError: You must specify a region
    "tst/generated/test_logs.py"
  ];

  meta = {
    description = "Python object-oriented interface for interacting with Amazon SageMaker resources";
    homepage = "https://github.com/aws/sagemaker-core";
    changelog = "https://github.com/aws/sagemaker-core/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
