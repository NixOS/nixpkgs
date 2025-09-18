{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  psycopg,
}:

buildPythonPackage rec {
  pname = "harlequin-postgres";
  version = "1.2.0";
  pyproject = true;

  src = fetchPypi {
    pname = "harlequin_postgres";
    inherit version;
    hash = "sha256-9US0aaXP2F+UVM9pY43KpnB05KC0/uDxrpZAYOJ+RR0=";
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
    description = "Harlequin adapter for Postgres";
    homepage = "https://pypi.org/project/harlequin-postgres/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pcboy ];
  };
}
