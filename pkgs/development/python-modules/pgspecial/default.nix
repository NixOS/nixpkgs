{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, psycopg
, click
, configobj
, sqlparse
}:

buildPythonPackage rec {
  pname = "pgspecial";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CZqcQ7V2iIWpnHYbHxSoxlBLsU6WMa2HVXOa2vdYJm8=";
  };

  propagatedBuildInputs = [
    click
    sqlparse
    psycopg
  ];

  nativeCheckInputs = [
    configobj
    pytestCheckHook
  ];

  disabledTests = [
    # requires a postgresql server
    "test_slash_dp_pattern_schema"
  ];

  meta = with lib; {
    description = "Meta-commands handler for Postgres Database";
    homepage = "https://github.com/dbcli/pgspecial";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
