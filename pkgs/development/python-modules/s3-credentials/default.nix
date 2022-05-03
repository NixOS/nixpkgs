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
  version = "0.11";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = version;
    hash = "sha256-t6Q+/2k93cEk+eeFm9aOvZNb1IcUzt66iApfH2FvHbw=";
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
