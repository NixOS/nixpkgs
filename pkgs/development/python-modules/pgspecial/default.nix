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
  version = "2.1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8EGeGzt4+zpy/jtUb2eIpxIJFTLVmf51k7X27lWoj4c=";
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
