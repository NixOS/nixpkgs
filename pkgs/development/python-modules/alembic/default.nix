{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytestcov, mock, coverage, setuptools
, Mako, sqlalchemy, python-editor, dateutil
}:

buildPythonPackage rec {
  pname = "alembic";
  version = "1.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3b0cb1948833e062f4048992fbc97ecfaaaac24aaa0d83a1202a99fb58af8c6d";
  };

  buildInputs = [ pytest pytestcov mock coverage ];
  propagatedBuildInputs = [ Mako sqlalchemy python-editor dateutil setuptools ];

  # no traditional test suite
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://bitbucket.org/zzzeek/alembic;
    description = "A database migration tool for SQLAlchemy";
    license = licenses.mit;
  };
}
