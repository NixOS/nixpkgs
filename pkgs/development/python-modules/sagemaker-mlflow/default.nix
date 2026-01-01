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
<<<<<<< HEAD
  version = "0.2.0";
=======
  version = "0.1.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "sagemaker-mlflow";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-EmfEqL+J+cZVdBfUJtAPHpUZCoDV4X1yRfVJYWky1HU=";
  };

=======
    hash = "sha256-mHwlP1bVkUiT6RbVf8YLHG+tzkw5+UVrPzcExgcEoJM=";
  };

  postPatch = ''
    substituteInPlace VERSION \
      --replace-fail "${version}.dev0" "${version}"
  '';

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  build-system = [
    setuptools
  ];

  dependencies = [
    boto3
    mlflow
  ];

<<<<<<< HEAD
  pythonImportsCheck = [ "sagemaker_mlflow" ];
=======
  pythonImportsCheck = [
    "sagemaker_mlflow"
  ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
