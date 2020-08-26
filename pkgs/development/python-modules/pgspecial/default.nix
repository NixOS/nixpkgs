{ stdenv, buildPythonPackage, fetchPypi, pytest, psycopg2, click, sqlparse }:

buildPythonPackage rec {
  pname = "pgspecial";
  version = "1.11.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jrq6bhzwvz6db8ays8zff15hbk1iazs2qxrzvrnlkgxxjkp8p7n";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ click sqlparse psycopg2 ];

  checkPhase = ''
    find tests -name \*.pyc -delete
    py.test tests
  '';

  meta = with stdenv.lib; {
    description = "Meta-commands handler for Postgres Database";
    homepage = "https://pypi.python.org/pypi/pgspecial";
    license = licenses.bsd3;
  };
}
