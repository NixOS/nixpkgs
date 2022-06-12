{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, psycopg2
, click
, configobj
, sqlparse
}:

buildPythonPackage rec {
  pname = "pgspecial";
  version = "1.13.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1dq5ZpCQgnWRbcLGIu+uIX8ULggWX6NmlJ1By8VlhwE=";
  };

  propagatedBuildInputs = [
    click
    sqlparse
    psycopg2
  ];

  checkInputs = [
    configobj
    pytestCheckHook
  ];

  disabledTests = [
    # requires a postgresql server
    "test_slash_dp_pattern_schema"
  ];

  meta = with lib; {
    description = "Meta-commands handler for Postgres Database";
    homepage = "https://pypi.python.org/pypi/pgspecial";
    license = licenses.bsd3;
  };
}
