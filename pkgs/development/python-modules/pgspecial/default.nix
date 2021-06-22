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
  version = "1.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3847e205b19469f16ded05bda24b4758056d67ade4075a5ded4ce6628a9bad01";
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

  meta = with lib; {
    description = "Meta-commands handler for Postgres Database";
    homepage = "https://pypi.python.org/pypi/pgspecial";
    license = licenses.bsd3;
  };
}
