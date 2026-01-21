{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  psycopg,
}:

buildPythonPackage rec {
  pname = "harlequin-postgres";
  version = "1.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "harlequin_postgres";
    inherit version;
    hash = "sha256-01MllGk8dFeWtbpENCGGYs4/nlq7aLLkFZqCXGLrN4s=";
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
