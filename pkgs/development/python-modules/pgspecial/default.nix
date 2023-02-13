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
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ZEQ7vJrQm1fQ9Ny7OO/0TVKFO3QYyepS9YV6vhu1NOw=";
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
