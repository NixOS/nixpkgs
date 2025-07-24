{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  django,
  python-dateutil,
  freezegun,
  psycopg2,
  postgresql,
  postgresqlTestHook,
  python,
}:

buildPythonPackage rec {
  pname = "django-auditlog";
  version = "3.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-auditlog";
    tag = "v${version}";
    hash = "sha256-xb6pTsXkB8HVpXvB9WzBUlRcjh5cn1CdmMYQQVCQ/GU=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    django
    python-dateutil
  ];

  nativeCheckInputs = [
    freezegun
    psycopg2
    postgresql
    postgresqlTestHook
  ];

  doCheck = stdenv.hostPlatform.isLinux; # postgres fails to allocate shm on darwin

  postgresqlTestUserOptions = "LOGIN SUPERUSER";

  checkPhase = ''
    runHook preCheck

    cd auditlog_tests
    # strip escape codes otherwise tests fail
    # see https://github.com/jazzband/django-auditlog/issues/644
    TEST_DB_USER=$PGUSER \
    TEST_DB_HOST=$PGHOST \
    ${python.interpreter} ./manage.py test | cat
    cd ..

    runHook postCheck
  '';

  pythonImportsCheck = [ "auditlog" ];

  meta = {
    changelog = "https://github.com/jazzband/django-auditlog/blob/${src.tag}/CHANGELOG.md";
    description = "Django app that keeps a log of changes made to an object";
    downloadPage = "https://github.com/jazzband/django-auditlog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ leona ];
  };
}
