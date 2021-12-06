{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, snowflake-connector-python
, requests
, cryptography
, dbt-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dbt-snowflake";
  version = "0.21.0";

  disabled = pythonOlder "3.7";

  propagatedBuildInputs = [
    dbt-core
    snowflake-connector-python
    requests
    cryptography
  ];

  checkInputs = [
    pytestCheckHook
  ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9jVGO8+idqw02WA/KAjao8OkS7HzYgnv/5zzURHQAU4=";
  };

  meta = with lib; {
    description = "Snowflake adpter plugin for dbt";
    homepage = "https://getdbt.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ shikanime ];
  };
}
