{ lib
, buildPythonPackage
, django
, netaddr
, six
, fetchFromGitHub
, pythonOlder
# required for tests
#, djangorestframework
#, psycopg2
}:

buildPythonPackage rec {
  pname = "django-postgresql-netfields";
  version = "1.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jimfunk";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-I+X4yfadtiiZlW7QhfwVbK1qyWn/khH9fWXszCo9uro=";
  };

  propagatedBuildInputs = [
    django
    netaddr
    six
  ];

  # tests need a postgres database
  doCheck = false;

  # keeping the dependencies below as comment for reference
  # checkPhase = ''
    # python manage.py test
  # '';

  # buildInputs = [
    # djangorestframework
    # psycopg2
  # ];

  # Requires psycopg2
  # pythonImportsCheck = [
  #   "netfields"
  # ];

  meta = with lib; {
    description = "Django PostgreSQL netfields implementation";
    homepage = "https://github.com/jimfunk/django-postgresql-netfields";
    changelog = "https://github.com/jimfunk/django-postgresql-netfields/blob/v${version}/CHANGELOG";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
