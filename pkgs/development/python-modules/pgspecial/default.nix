{ stdenv, buildPythonPackage, fetchPypi, pytest, psycopg2, click, sqlparse }:

buildPythonPackage rec {
  pname = "pgspecial";
  version = "1.11.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "77f8651450ccbde7d3036cfe93486a4eeeb5ade28d1ebc4b2ba186fea0023c56";
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
