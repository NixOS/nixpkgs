{
  lib,
  anyascii,
  buildPythonPackage,
  fetchFromGitHub,
  flaky,
  google-cloud-storage,
  legacy-cgi,
  mock,
  pillow,
  pymongo,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  requests,
  setuptools,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "filedepot";
  version = "0.11.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "amol-";
    repo = "depot";
    tag = version;
    hash = "sha256-693H/u+Wg2G9sdoUkC6DQo9WkmIlKnh8NKv3ufK/eyQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    anyascii
    legacy-cgi
    google-cloud-storage
  ];

  nativeCheckInputs = [
    flaky
    mock
    pillow
    pymongo
    pytestCheckHook
    requests
    sqlalchemy
  ];

  disabledTestPaths = [
    # ModuleNotFoundError: No module named 'depot._pillow_compat'
    "tests/test_fields_sqlalchemy.py"
    # The examples have tests
    "examples"
    # Missing dependencies (TurboGears2 and ming)
    "tests/test_fields_ming.py"
    "tests/test_wsgi_middleware.py"
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.13") [ "test_notexisting" ];

  pythonImportsCheck = [ "depot" ];

  meta = with lib; {
    description = "Toolkit for storing files and attachments in web applications";
    homepage = "https://github.com/amol-/depot";
    changelog = "https://github.com/amol-/depot/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
