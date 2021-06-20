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
  version = "1.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b68feb0005f57861573d3fbb82c5c777950decfbb2d1624af57aec825db02c02";
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
