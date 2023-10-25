{ stdenv
, lib
, buildPythonPackage
, django
, netaddr
, six
, fetchFromGitHub
, pythonOlder
, djangorestframework
# required for tests
, postgresql
, postgresqlTestHook
, psycopg2
, pytestCheckHook
, pytest-django
}:

buildPythonPackage rec {
  pname = "django-postgresql-netfields";
  version = "1.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jimfunk";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-76vGvxxfNZQBCCsTkkSgQZ8PpFspWxJQDj/xq9iOSTU=";
  };

  propagatedBuildInputs = [
    django
    netaddr
    six
  ];

  doCheck = !stdenv.isDarwin; # could not create shared memory segment: Operation not permitted

  nativeCheckInputs = [
    djangorestframework
    postgresql
    postgresqlTestHook
    psycopg2
    pytestCheckHook
    pytest-django
  ];

  postgresqlTestUserOptions = "LOGIN SUPERUSER";
  env.DJANGO_SETTINGS_MODULE = "testsettings";

  meta = with lib; {
    description = "Django PostgreSQL netfields implementation";
    homepage = "https://github.com/jimfunk/django-postgresql-netfields";
    changelog = "https://github.com/jimfunk/django-postgresql-netfields/blob/v${version}/CHANGELOG";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
