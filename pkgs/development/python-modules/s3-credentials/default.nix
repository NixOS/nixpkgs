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
  version = "0.12.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-w0pwQidSAh/CQPVbv4UocbbETyyOT/rcNFE1ixYz4lY=";
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
