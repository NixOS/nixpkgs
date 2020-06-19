{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytestcov, mock, coverage, setuptools
, Mako, sqlalchemy, python-editor, dateutil
}:

buildPythonPackage rec {
  pname = "alembic";
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "035ab00497217628bf5d0be82d664d8713ab13d37b630084da8e1f98facf4dbf";
  };

  buildInputs = [ pytest pytestcov mock coverage ];
  propagatedBuildInputs = [ Mako sqlalchemy python-editor dateutil setuptools ];

  # no traditional test suite
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://bitbucket.org/zzzeek/alembic";
    description = "A database migration tool for SQLAlchemy";
    license = licenses.mit;
  };
}
