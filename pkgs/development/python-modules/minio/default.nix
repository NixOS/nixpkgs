{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build-system
, setuptools

# dependencies
, argon2-cffi
, certifi
, urllib3
, pycryptodome

# test
, faker
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "minio";
  version = "7.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "minio-py";
    rev = "refs/tags/${version}";
    hash = "sha256-hZn1T75JbnJ5lIyWnX3f8r6OET/d6ZltuRr6jjYOp2o=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    argon2-cffi
    certifi
    urllib3
    pycryptodome
  ];

  nativeCheckInputs = [
    faker
    mock
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
