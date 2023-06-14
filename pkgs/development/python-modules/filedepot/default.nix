{ lib
, anyascii
, buildPythonPackage
, fetchFromGitHub
, flaky
, mock
, paste
, pillow
, pymongo
, pytestCheckHook
, pythonOlder
, requests
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "filedepot";
  version = "0.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "amol-";
    repo = "depot";
    rev = "refs/tags/${version}";
    hash = "sha256-OJc4Qwar3sKhKKF1WldwaueRG7FCboWT2wXYldHJbPU=";
  };

  propagatedBuildInputs = [
    anyascii
  ];

  nativeCheckInputs = [
    flaky
    mock
    paste
    pillow
    pymongo
    pytestCheckHook
    requests
    sqlalchemy
  ];

  disabledTestPaths = [
    # The examples have tests
    "examples"
    # Missing dependencies (TurboGears2 and ming)
    "tests/test_fields_ming.py"
    "tests/test_wsgi_middleware.py"
  ];

  pythonImportsCheck = [
    "depot"
  ];

  meta = with lib; {
    description = "Toolkit for storing files and attachments in web applications";
    homepage = "https://github.com/amol-/depot";
    changelog = "https://github.com/amol-/depot/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
