{ lib
, buildPythonPackage
, django
, netaddr
, six
, fetchFromGitHub
# required for tests
#, djangorestframework
#, psycopg2
}:

buildPythonPackage rec {
  version = "1.3.0";
  pname = "django-postgresql-netfields";

  src = fetchFromGitHub {
    owner = "jimfunk";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-I+X4yfadtiiZlW7QhfwVbK1qyWn/khH9fWXszCo9uro=";
  };

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

  propagatedBuildInputs = [
    django
    netaddr
    six
  ];

  meta = with lib; {
    description = "Django PostgreSQL netfields implementation";
    homepage = "https://github.com/jimfunk/django-postgresql-netfields";
    license = licenses.bsd2;
  };
}
