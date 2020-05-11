{ stdenv, buildPythonPackage, fetchPypi, pytest, psycopg2, click, sqlparse }:

buildPythonPackage rec {
  pname = "pgspecial";
  version = "1.11.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f65c74a7ecfd4d6af3feb963a1bf8a612e5882731f69afd06ae66ffee13238cb";
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
