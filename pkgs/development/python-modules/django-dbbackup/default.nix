{
  buildPythonPackage,
  coverage,
  django,
  django-storages,
  fetchFromGitHub,
  flake8,
  gnupg,
  lib,
  pep8,
  psycopg2,
  pylint,
  pytest-django,
  pytestCheckHook,
  python-dotenv,
  python-gnupg,
  pytz,
  setuptools,
  testfixtures,
  tox,
  pythonOlder,
}:
buildPythonPackage rec {
  pname = "django-dbbackup";
  version = "4.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-dbbackup";
    repo = "django-dbbackup";
    tag = version;
    hash = "sha256-w+LfU5I7swnCJpwqBqoCTRUCZjKoIxK3OC+8CrihLEI=";
  };

  disabled = pythonOlder "3.9";

  dependencies = [
    django
    python-gnupg
    pytz
  ];

  build-system = [ setuptools ];
  doCheck = true;
  preCheck = ''
    tempDir=$(mktemp -d)
    export HOME=$tempDir
    export DJANGO_SETTINGS_MODULE=dbbackup.tests.settings
  '';
  pythonImportsCheck = [ "dbbackup" ];
  disabledTestPaths = [
    # Specific gnupg version required, which aren't provided in upstream
    "dbbackup/tests/commands/test_dbrestore.py::DbrestoreCommandRestoreBackupTest::test_decrypt"
    "dbbackup/tests/test_connectors/test_base.py::BaseCommandDBConnectorTest::test_run_command_with_parent_env"
    "dbbackup/tests/test_utils.py::Encrypt_FileTest::test_func"
    "dbbackup/tests/test_utils.py::Compress_FileTest::test_func"
  ];
  nativeCheckInputs = [
    coverage
    django-storages
    flake8
    gnupg
    pep8
    psycopg2
    pylint
    pytest-django
    pytestCheckHook
    python-dotenv
    testfixtures
    tox
  ];

  meta = with lib; {
    description = "Management commands to help backup and restore your project database and media files";
    homepage = "https://github.com/Archmonger/django-dbbackup";
    changelog = "https://github.com/Archmonger/django-dbbackup/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kurogeek ];
  };
}
