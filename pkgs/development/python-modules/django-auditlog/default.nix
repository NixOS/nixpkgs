{
  lib,
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
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-auditlog";
    rev = "v${version}";
    hash = "sha256-SJ4GJp/gVIxiLbdAj3ZS+weevqIDZCMQnW/pqc5liJU=";
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

  postgresqlTestUserOptions = "LOGIN SUPERUSER";

  checkPhase = ''
    runHook preCheck

    # strip escape codes otherwise tests fail
    # see https://github.com/jazzband/django-auditlog/issues/644
    TEST_DB_USER=$PGUSER \
    TEST_DB_HOST=$PGHOST \
    ${python.interpreter} runtests.py | cat

    runHook postCheck
  '';

  pythonImportsCheck = [ "auditlog" ];

  meta = with lib; {
    changelog = "https://github.com/jazzband/django-auditlog/blob/v${version}/CHANGELOG.md";
    description = "Django app that keeps a log of changes made to an object";
    downloadPage = "https://github.com/jazzband/django-auditlog";
    license = licenses.mit;
    maintainers = with maintainers; [ leona ];
  };
}
