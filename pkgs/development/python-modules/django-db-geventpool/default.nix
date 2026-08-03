{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  django,
  psycopg,
  gevent,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-db-geventpool";
  version = "4.0.8";
  pyproject = true;

  src = fetchPypi {
    pname = "django_db_geventpool";
    inherit (finalAttrs) version;
    hash = "sha256-jqEA5IFRUnL3bHf03zuzQBzoOMl1SXgtDTD6+ZDQy/Q=";
  };

  build-system = [ hatchling ];

  dependencies = [
    django
    psycopg
    gevent
  ];

  pythonImportsCheck = [ "django_db_geventpool" ];

  meta = {
    description = "Another DB pool using gevent for PostgreSQL DB";
    homepage = "https://github.com/jneight/django-db-geventpool";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ staticdev ];
  };
})
