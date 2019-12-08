{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytestcov, mock, coverage, setuptools
, Mako, sqlalchemy, python-editor, dateutil
}:

buildPythonPackage rec {
  pname = "alembic";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9f907d7e8b286a1cfb22db9084f9ce4fde7ad7956bb496dc7c952e10ac90e36a";
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
