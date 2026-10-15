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
  matplotlib,
  pandas,
  pytestCheckHook,
  scikit-learn,
  skops,
}:

buildPythonPackage (finalAttrs: {
  pname = "sagemaker-mlflow";
  version = "0.5.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "sagemaker-mlflow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nSI1BGJ2hhzuHxnGjElDuPpuc2rRn2mX5+s4ZSuZna0=";
  };

  # AssertionError: sagemaker_mlflow version is dev - 0.5.0.dev1
  postPatch = ''
    substituteInPlace VERSION \
      --replace-fail \
        "0.5.0.dev1" \
        "${finalAttrs.version}"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    boto3
    mlflow-skinny
  ];

  pythonImportsCheck = [ "sagemaker_mlflow" ];

  nativeCheckInputs = [
    matplotlib
    pandas
    pytestCheckHook
    scikit-learn
    skops
  ];

  # mlflow.exceptions.MlflowException: The filesystem tracking backend (e.g., './mlruns') is in maintenance mode and will not receive further updates.
  # Please migrate to a database backend (e.g., 'sqlite:///mlflow.db') to access the latest MLflow features.
  preCheck = ''
    export MLFLOW_ALLOW_FILE_STORE=true
  '';

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
    changelog = "https://github.com/aws/sagemaker-mlflow/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
