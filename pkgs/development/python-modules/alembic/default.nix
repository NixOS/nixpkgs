{ lib, buildPythonPackage, fetchPypi
, pytest, pytest-cov, mock, coverage, setuptools
, Mako, sqlalchemy, python-editor, python-dateutil
}:

buildPythonPackage rec {
  pname = "alembic";
  version = "1.6.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a21fedebb3fb8f6bbbba51a11114f08c78709377051384c9c5ead5705ee93a51";
  };

  buildInputs = [ pytest pytest-cov mock coverage ];
  propagatedBuildInputs = [ Mako sqlalchemy python-editor python-dateutil setuptools ];

  # no traditional test suite
  doCheck = false;

  meta = with lib; {
    homepage = "https://bitbucket.org/zzzeek/alembic";
    description = "A database migration tool for SQLAlchemy";
    license = licenses.mit;
  };
}
