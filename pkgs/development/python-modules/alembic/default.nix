{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytestcov, mock, coverage, setuptools
, Mako, sqlalchemy, python-editor, dateutil
}:

buildPythonPackage rec {
  pname = "alembic";
  version = "1.0.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "828dcaa922155a2b7166c4f36ec45268944e4055c86499bd14319b4c8c0094b7";
  };

  buildInputs = [ pytest pytestcov mock coverage ];
  propagatedBuildInputs = [ Mako sqlalchemy python-editor dateutil setuptools ];

  meta = with stdenv.lib; {
    homepage = https://bitbucket.org/zzzeek/alembic;
    description = "A database migration tool for SQLAlchemy";
    license = licenses.mit;
  };
}
