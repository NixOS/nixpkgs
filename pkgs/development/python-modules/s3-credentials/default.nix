{
  lib,
  boto3,
  buildPythonPackage,
  click,
  click-default-group,
  fetchFromGitHub,
  hypothesis,
  moto,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "s3-credentials";
  version = "0.16.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "s3-credentials";
    tag = version;
    hash = "sha256-TuGrKSfnn0CSMpRxdCM6C446z+y9d2ZLB7+wSCxSqP4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    boto3
    click
    click-default-group
  ];

  nativeCheckInputs = [
    hypothesis
    moto
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "s3_credentials" ];

  disabledTests = [
    # AssertionError: assert 'directory/th...ory/...
    "test_put_objects"
  ];

  meta = with lib; {
    description = "Python CLI utility for creating credentials for accessing S3 buckets";
    homepage = "https://github.com/simonw/s3-credentials";
    changelog = "https://github.com/simonw/s3-credentials/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ techknowlogick ];
    mainProgram = "s3-credentials";
  };
}
