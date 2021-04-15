{ lib, buildPythonPackage, fetchPypi, pytest, psycopg2, click, sqlparse }:

buildPythonPackage rec {
  pname = "pgspecial";
  version = "1.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b68feb0005f57861573d3fbb82c5c777950decfbb2d1624af57aec825db02c02";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ click sqlparse psycopg2 ];

  checkPhase = ''
    find tests -name \*.pyc -delete
    py.test tests
  '';

  meta = with lib; {
    description = "Meta-commands handler for Postgres Database";
    homepage = "https://pypi.python.org/pypi/pgspecial";
    license = licenses.bsd3;
  };
}
