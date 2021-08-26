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
  version = "7.1.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "minio-py";
    rev = version;
    sha256 = "sha256-0N9hPjGGYHFyGzEWWDnW7KsPQtv0y/j/lCBLNC9IlpA=";
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
