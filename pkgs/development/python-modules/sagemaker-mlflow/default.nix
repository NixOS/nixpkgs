{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  boto3,
  mlflow-skinny,

  # tests
  pytestCheckHook,
  scikit-learn,
}:

buildPythonPackage (finalAttrs: {
  pname = "sagemaker-mlflow";
  version = "0.4.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "sagemaker-mlflow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QE40ZBW7N3GPC+eJqj5uzS3L+A6Wu2/LgHOiUsEXKMw=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    boto3
    mlflow-skinny
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

    # Exercises a `sqlite://` model-registry store, only available with the
    # sqlalchemy backend of the full `mlflow` package (not `mlflow-skinny`).
    "test_store_instantiation_none"
  ];

  disabledTestPaths = [
    # `from mlflow.models import infer_signature` fails to import at collection
    # time: `infer_signature` is only available in the full `mlflow` package,
    # not in `mlflow-skinny`. Also see:
    # https://github.com/aws/sagemaker-mlflow/issues/16
    "test/integration/tests/test_model_registry.py"
  ];

  meta = {
    description = "MLFlow plugin for SageMaker";
    homepage = "https://github.com/aws/sagemaker-mlflow";
    changelog = "https://github.com/aws/sagemaker-mlflow/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
