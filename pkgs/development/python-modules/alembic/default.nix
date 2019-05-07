{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytestcov, mock, coverage
, Mako, sqlalchemy, python-editor, dateutil
}:

buildPythonPackage rec {
  pname = "alembic";
  version = "1.0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "40b9a619aa5f25ea1e1508adcda88b33704ef28e02c9cfa6471e5c772ecf0829";
  };

  buildInputs = [ pytest pytestcov mock coverage ];
  propagatedBuildInputs = [ Mako sqlalchemy python-editor dateutil ];

  meta = with stdenv.lib; {
    homepage = https://bitbucket.org/zzzeek/alembic;
    description = "A database migration tool for SQLAlchemy";
    license = licenses.mit;
  };
}
