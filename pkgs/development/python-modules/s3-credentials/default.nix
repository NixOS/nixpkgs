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
}:

buildPythonPackage rec {
  pname = "s3-credentials";
  version = "0.13";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-kzu+ySeAi+nRIJSBSJUQzNHD7KVANlWoi0OWKXkc0/8=";
  };

  propagatedBuildInputs = [
    click
    click-default-group
    boto3
  ];

  checkInputs = [
    pytestCheckHook
    hypothesis
    pytest-mock
  ];

  pythonImportsCheck = [
    "s3_credentials"
  ];

  meta = with lib; {
    description = "Python CLI utility for creating credentials for accessing S3 buckets";
    homepage = "https://github.com/simonw/s3-credentials";
    license = licenses.asl20;
    maintainers = with maintainers; [ techknowlogick ];
  };
}
