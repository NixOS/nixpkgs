{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  sqlalchemy,
  requests,
  asynch,
  clickhouse-driver,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "clickhouse-sqlalchemy";
  version = "0.3.2-unstable-2025-11-24";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "xzkostyan";
    repo = "clickhouse-sqlalchemy";
    rev = "25721c3cd6e094ae1853327ab1de3a5d7144acbd";
    hash = "sha256-QCwxPZa3DUFCpZeyrynhd+xuXCyAmtNPRQtJqBbisqg=";
  };

  patches = [
    # Fix compatibility with newer dependencies and python versions (https://github.com/xzkostyan/clickhouse-sqlalchemy/pull/401)
    ./update-deps-and-python-version.patch
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    sqlalchemy
    requests
    clickhouse-driver
    asynch
  ];

  pythonImportsCheck = [
    "clickhouse_sqlalchemy"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "ClickHouse dialect for SQLAlchemy";
    homepage = "https://github.com/xzkostyan/clickhouse-sqlalchemy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jlesquembre
      joaosreis
    ];
  };
})
