{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, psycopg2
}:

buildPythonPackage rec {
  pname = "dbt-postgres";
  version = "0.21.0";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AMytEfzj5NQ/fobDmz6BOSQVMYntgojppyGyCz3IIqg=";
  };

  propagatedBuildInputs = [ psycopg2 ];

  meta = with lib; {
    description = "Postgres adpter plugin for dbt";
    homepage = "https://getdbt.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ shikanime ];
  };
}
