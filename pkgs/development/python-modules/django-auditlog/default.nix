{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, setuptools-scm
, django
, python-dateutil
, freezegun
, psycopg2
, postgresql
, postgresqlTestHook
, python
}:

buildPythonPackage rec {
  pname = "django-auditlog";
  version = "2.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QHSGqtpkOgltAg+RlG/Ik3DfEjtSWt45sqlD+Zw4Bh0=";
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

    TEST_DB_USER=$PGUSER \
    TEST_DB_HOST=$PGHOST \
    ${python.interpreter} runtests.py

    runHook postCheck
  '';

  pythonImportsCheck = [ "auditlog" ];

  meta = with lib; {
    changelog = "https://github.com/jazzband/django-auditlog/blob/v${version}/CHANGELOG.md";
    description = "A Django app that keeps a log of changes made to an object";
    downloadPage = "https://github.com/jazzband/django-auditlog";
    license = licenses.mit;
    maintainers = with maintainers; [ leona ];
  };
}
