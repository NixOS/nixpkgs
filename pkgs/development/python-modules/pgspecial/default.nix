{ stdenv, buildPythonPackage, fetchPypi, pytest, psycopg2, click, sqlparse }:

buildPythonPackage rec {
  pname = "pgspecial";
  version = "1.11.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0yvlxv9vy0hbfgf0xcwl7wh5hg6cl86arsv1ip3kvn9znn6x8kgl";
  };

  buildInputs = [ pytest psycopg2 ];
  propagatedBuildInputs = [ click sqlparse ];

  checkPhase = ''
    find tests -name \*.pyc -delete
    py.test tests
  '';

  meta = with stdenv.lib; {
    description = "Meta-commands handler for Postgres Database";
    homepage = https://pypi.python.org/pypi/pgspecial;
    license = licenses.bsd3;
  };
}
