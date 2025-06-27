{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  django,
  psycopg,
  python-dateutil,
}:

buildPythonPackage rec {
  pname = "django-postgres-partition";
  version = "0.1.4";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "django_postgres_partition";
    hash = "sha256-vyO4fplpFkkQBhhu52EGgjgyekgd8Q1Y7DpBTW5Drx8=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "django"
  ];

  dependencies = [
    django
    psycopg
    python-dateutil
  ];

  doCheck = false; # pypi version doesn't ship with tests

  pythonImportsCheck = [ "psql_partition" ];

  meta = {
    description = "Partition support for django, based on django-postgres-extra";
    homepage = "https://gitlab.com/burke-software/django-postgres-partition";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
  };
}
