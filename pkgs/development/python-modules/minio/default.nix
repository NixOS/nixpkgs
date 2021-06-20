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
  version = "7.0.3";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "minio-py";
    rev = version;
    sha256 = "14symk7b3i9xzfc2wkcnqmfsvh9j3jx2ijz7dgy1xyrbjwb7yzhc";
  };

  propagatedBuildInputs = [
    certifi
    configparser
    future
    python-dateutil
    pytz
    urllib3
  ];

  checkInputs = [
    faker
    mock
    nose
    pytestCheckHook
  ];

  # example credentials aren't present
  disabledTestPaths = [
    "tests/unit/credentials_test.py"
  ];

  pythonImportsCheck = [ "minio" ];

  meta = with lib; {
    description = "Simple APIs to access any Amazon S3 compatible object storage server";
    homepage = "https://github.com/minio/minio-py";
    maintainers = with maintainers; [ peterromfeldhk ];
    license = licenses.asl20;
  };
}
