{ stdenv, buildPythonPackage, fetchPypi, pytest, psycopg2, click, sqlparse }:

buildPythonPackage rec {
  pname = "pgspecial";
  version = "1.11.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yq3cmpdcvwsz3nifc0db125433vxbgbpmbhxfj46b9s5k81xs30";
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
