{ lib, buildPythonPackage, fetchPypi
, pytest, pytestcov, mock, coverage, setuptools
, Mako, sqlalchemy, python-editor, dateutil
}:

buildPythonPackage rec {
  pname = "alembic";
  version = "1.5.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e27fd67732c97a1c370c33169ef4578cf96436fa0e7dcfaeeef4a917d0737d56";
  };

  buildInputs = [ pytest pytestcov mock coverage ];
  propagatedBuildInputs = [ Mako sqlalchemy python-editor dateutil setuptools ];

  # no traditional test suite
  doCheck = false;

  meta = with lib; {
    homepage = "https://bitbucket.org/zzzeek/alembic";
    description = "A database migration tool for SQLAlchemy";
    license = licenses.mit;
  };
}
