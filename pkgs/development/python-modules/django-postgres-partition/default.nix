{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  django_5_2,
  psycopg,
  python-dateutil,
}:

buildPythonPackage rec {
  pname = "django-postgres-partition";
  version = "0.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "django_postgres_partition";
    hash = "sha256-KUrgnfUXWyRerW4dqtVZO9bu5jHYnHcVOIg97w695RU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django_5_2
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
