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
}:

buildPythonPackage rec {
  pname = "sagemaker-core";
  version = "1.0.22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "sagemaker-core";
    tag = "v${version}";
    hash = "sha256-RoLLgOhG4M71Nx1aryDt1mt0sZ2zEqYRJTjQRSVuf8M=";
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

  # Only a single test which fails with:
  # ValueError: Must setup local AWS configuration with a region supported by SageMaker.
  doCheck = false;

  meta = {
    description = "Python SDK designed to provide an object-oriented interface for interacting with Amazon SageMaker resources";
    homepage = "https://github.com/aws/sagemaker-core";
    changelog = "https://github.com/aws/sagemaker-core/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
