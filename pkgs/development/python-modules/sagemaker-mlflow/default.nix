{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  boto3,
  mlflow,

  # tests
  pytestCheckHook,
  scikit-learn,
}:

buildPythonPackage rec {
  pname = "sagemaker-mlflow";
  version = ".0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "sagemaker-mlflow";
    tag = "v${version}";
    hash = "sha256-EmfEqL+J+cZVdBfUJtAPHpUZCoDV4X1yRfVJYWky1HU=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    boto3
    mlflow
  ];

  pythonImportsCheck = [ "sagemaker_mlflow" ];

  nativeCheckInputs = [
    pytestCheckHook
    scikit-learn
  ];

  disabledTests = [
    # AssertionError: assert 's3' in '/build/source/not implemented/0/d3c16d2bad4245bf9fc68f86d2e7599d/artifacts'
    "test_log_metric"

    # AssertionError: assert 'not implemented' == 'mw'
    "test_request_header"

    # Require internet access
    "test_auth_provider_returns_correct_sigv4"
    "test_log_artifact"
    "test_presigned_url"
    "test_presigned_url_with_fields"
  ];

  meta = {
    description = "MLFlow plugin for SageMaker";
    homepage = "https://github.com/aws/sagemaker-mlflow";
    changelog = "https://github.com/aws/sagemaker-mlflow/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
