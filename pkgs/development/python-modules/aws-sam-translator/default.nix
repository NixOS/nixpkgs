{
  lib,
  boto3,
  buildPythonPackage,
  fetchFromGitHub,
  jsonschema,
  parameterized,
  pydantic,
  pytest-env,
  pytest-rerunfailures,
  pytest-xdist,
  pytestCheckHook,
  pyyaml,
  requests,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "aws-sam-translator";
  version = "1.110.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "serverless-application-model";
    tag = "v${version}";
    hash = "sha256-Zn+6cDyDZSsV9V+zAA8BOPs4aKl0j3dF92/azGYG+OI=";
  };

  postPatch = ''
    # don't try to use --cov or fail on new warnings
    rm pytest.ini
  '';

  pythonRelaxDeps = [ "pydantic" ];

  build-system = [ setuptools ];

  dependencies = [
    boto3
    jsonschema
    pydantic
    typing-extensions
  ];

  nativeCheckInputs = [
    parameterized
    pytest-env
    pytest-rerunfailures
    pytest-xdist
    pytestCheckHook
    pyyaml
    requests
  ];

  preCheck = ''
    export AWS_DEFAULT_REGION=us-east-1
  '';

  enabledTestPaths = [
    "tests"
  ];

  disabledTestMarks = [
    "slow"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "samtranslator" ];

  meta = {
    description = "Python library to transform SAM templates into AWS CloudFormation templates";
    homepage = "https://github.com/aws/serverless-application-model";
    changelog = "https://github.com/aws/serverless-application-model/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
