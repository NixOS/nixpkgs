{ stdenv, buildPythonPackage, fetchPypi, pytest, psycopg2, click, sqlparse }:

buildPythonPackage rec {
  pname = "pgspecial";
  version = "1.11.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f183da55c37128f7a74fe5b28e997991156f19961e59a1ad0f400ffc9535faba";
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
