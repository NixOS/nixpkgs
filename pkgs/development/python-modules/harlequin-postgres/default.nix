{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  psycopg,
}:

buildPythonPackage rec {
  pname = "harlequin-postgres";
  version = "1.1.1";
  pyproject = true;

  src = fetchPypi {
    pname = "harlequin_postgres";
    inherit version;
    hash = "sha256-O6CYGzsXqnKYS7NuoW3B6sM5it4jxZ/RSsb4g+HKNps=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    psycopg
    psycopg.pool
  ];

  # To prevent circular dependency
  # as harlequin-postgres requires harlequin which requires harlequin-postgres
  doCheck = false;
  pythonRemoveDeps = [
    "harlequin"
  ];

  meta = {
    description = "A Harlequin adapter for Postgres";
    homepage = "https://pypi.org/project/harlequin-postgres/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pcboy ];
  };
}
