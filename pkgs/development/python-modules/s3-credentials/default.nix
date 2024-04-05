{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, click
, click-default-group
, boto3
, pytestCheckHook
, hypothesis
, pytest-mock
, moto
}:

buildPythonPackage rec {
  pname = "s3-credentials";
  version = "0.16.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-TuGrKSfnn0CSMpRxdCM6C446z+y9d2ZLB7+wSCxSqP4=";
  };

  propagatedBuildInputs = [
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

  pythonImportsCheck = [
    "s3_credentials"
  ];

  disabledTests = [
    # AssertionError: assert 'directory/th...ory/...
    "test_put_objects"
  ];

  meta = with lib; {
    description = "Python CLI utility for creating credentials for accessing S3 buckets";
    mainProgram = "s3-credentials";
    homepage = "https://github.com/simonw/s3-credentials";
    license = licenses.asl20;
    maintainers = with maintainers; [ techknowlogick ];
  };
}
