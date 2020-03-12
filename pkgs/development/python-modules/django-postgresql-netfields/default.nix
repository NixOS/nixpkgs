{ stdenv
, buildPythonPackage
, django
, netaddr
, six
, fetchFromGitHub
# required for tests
#, djangorestframework
#, psycopg2
#, unittest2
}:

buildPythonPackage rec {
  version = "1.2.2";
  pname = "django-postgresql-netfields";

  src = fetchFromGitHub {
    owner = "jimfunk";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "1rrh38f3zl3jk5ijs6g75dxxvxygf4lczbgc7ahrgzf58g4a48lm";
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
    # unittest2
  # ];

  propagatedBuildInputs = [
    django
    netaddr
    six
  ];

  meta = with stdenv.lib; {
    description = "Django PostgreSQL netfields implementation";
    homepage = https://github.com/jimfunk/django-postgresql-netfields;
    license = licenses.bsd2;
  };
}
