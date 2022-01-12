{ lib
, botocore
, buildPythonPackage
, docutils
, fetchFromGitHub
, mock
, pytestCheckHook
, pythonOlder
, wheel
}:

buildPythonPackage rec {
  pname = "s3transfer";
  version = "0.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "boto";
    repo = pname;
    rev = version;
    hash = "sha256-0Dl7oKB2xxq/a8do3HgBUIGay88yOGBUdOGo+QCtnUE=";
  };

  propagatedBuildInputs = [
    botocore
  ];

  buildInputs = [
    docutils
    mock
    pytestCheckHook
    wheel
  ];

  disabledTestPaths = [
    # Requires network access
    "tests/integration/test_copy.py"
    "tests/integration/test_delete.py"
    "tests/integration/test_download.py"
    "tests/integration/test_processpool.py"
    "tests/integration/test_s3transfer.py"
    "tests/integration/test_upload.py"
  ];

  pythonImportsCheck = [
    "s3transfer"
  ];

  meta = with lib; {
    description = "Library for managing Amazon S3 transfers";
    homepage = "https://github.com/boto/s3transfer";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
