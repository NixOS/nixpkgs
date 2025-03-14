{
  lib,
  agate,
  buildPythonPackage,
  fetchFromGitHub,
  dbt-adapters,
  dbt-common,
  dbt-core,
  hatchling,
  psycopg2,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "dbt-postgres";
  version = "1.9.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = "dbt-postgres";
    tag = "v${version}";
    hash = "sha256-lywWf78rluX17D5bcfehHd7X18tAdw3HZ65v440jETc=";
  };

  build-system = [ hatchling ];

  pythonRemoveDeps = [ "psycopg2-binary" ];

  dependencies = [
    agate
    dbt-adapters
    dbt-common
    dbt-core
    psycopg2
  ];

  # tests exist for the dbt tool but not for this package specifically
  doCheck = false;

  pythonImportsCheck = [ "dbt.adapters.postgres" ];

  meta = with lib; {
    description = "Plugin enabling dbt to work with a Postgres database";
    homepage = "https://github.com/dbt-labs/dbt-core";
    license = licenses.asl20;
    maintainers = with maintainers; [ tjni ];
  };
}
