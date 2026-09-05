{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  sqlalchemy,
  requests,
  clickhouse-driver,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "clickhouse-sqlalchemy";
  version = "0.3.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Jn86mh0NGG65mkGJWmhJItMRJc6iFwLNfcc68czdEOc=";
  };

  build-system = [
    setuptools
  ];

  # asynch is not packaged in nixpkgs; drop it from install_requires
  # and disable the corresponding sqlalchemy dialect entry point.
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'asynch>=0.2.2'," "" \
      --replace-fail "('.asynch', 'asynch.base:ClickHouseDialect_asynch')," ""
  '';

  dependencies = [
    sqlalchemy
    requests
    clickhouse-driver
  ];

  pythonImportsCheck = [
    "clickhouse_sqlalchemy"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple ClickHouse SQLAlchemy Dialect";
    homepage = "https://pypi.org/project/clickhouse-sqlalchemy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
