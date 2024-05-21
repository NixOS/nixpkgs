{ lib
, agate
, buildPythonPackage
, dbt-core
, psycopg2
, pythonOlder
, setuptools
}:

buildPythonPackage {
  pname = "dbt-postgres";
  pyproject = true;

  inherit (dbt-core) version src;

  disabled = pythonOlder "3.7";

  sourceRoot = "${dbt-core.src.name}/plugins/postgres";

  env.DBT_PSYCOPG2_NAME = "psycopg2";

  build-system = [
    setuptools
  ];

  dependencies = [
    agate
    dbt-core
    psycopg2
  ];

  # tests exist for the dbt tool but not for this package specifically
  doCheck = false;

  pythonImportsCheck = [
    "dbt.adapters.postgres"
  ];

  meta = with lib; {
    description = "Plugin enabling dbt to work with a Postgres database";
    homepage = "https://github.com/dbt-labs/dbt-core";
    license = licenses.asl20;
    maintainers = with maintainers; [ tjni ];
  };
}
