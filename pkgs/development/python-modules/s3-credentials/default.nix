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
  version = "0.10";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = version;
    hash = "sha256-JgqKmZG3K4JwQ1Bzw2oll/LQ1njA9wFhX0/uYr9XjAU=";
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
