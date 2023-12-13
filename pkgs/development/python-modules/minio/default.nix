{ lib
, buildPythonPackage
, certifi
, configparser
, faker
, fetchFromGitHub
, future
, mock
, nose
, pytestCheckHook
, python-dateutil
, pythonOlder
, pytz
, urllib3
}:

buildPythonPackage rec {
  pname = "minio";
  version = "7.1.17";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "minio-py";
    rev = "refs/tags/${version}";
    hash = "sha256-I0Q1SkZ1zQ9s2HbMTc2EzUnnOti14zQBxHVJasaukug=";
  };

  propagatedBuildInputs = [
    certifi
    configparser
    future
    python-dateutil
    pytz
    urllib3
  ];

  nativeCheckInputs = [
    faker
    mock
    nose
    pytestCheckHook
  ];

  disabledTestPaths = [
    # example credentials aren't present
    "tests/unit/credentials_test.py"
  ];

  pythonImportsCheck = [
    "minio"
  ];

  meta = with lib; {
    description = "Simple APIs to access any Amazon S3 compatible object storage server";
    homepage = "https://github.com/minio/minio-py";
    changelog = "https://github.com/minio/minio-py/releases/tag/${version}";
    maintainers = with maintainers; [ peterromfeldhk ];
    license = licenses.asl20;
  };
}
