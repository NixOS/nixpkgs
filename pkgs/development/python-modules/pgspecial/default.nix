{ stdenv, buildPythonPackage, fetchPypi, pytest, psycopg2, click, sqlparse }:

buildPythonPackage rec {
  pname = "pgspecial";
  version = "1.11.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8c53fa2b2490fa9ec34ede4eafff8ddbe8bce5cba3dcae96509be36ec8c75575";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ click sqlparse psycopg2 ];

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
