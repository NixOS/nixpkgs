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
<<<<<<< HEAD
  version = "7.1.16";
=======
  version = "7.1.14";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "minio-py";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-avGCAaqP2gLlrLDFzUJZW/KaT2lrueVjgsAJSk1eyX0=";
=======
    hash = "sha256-GT9XMHzEOg04DZ/saacBfqAKc5A755m2zblJvwQjd1w=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
