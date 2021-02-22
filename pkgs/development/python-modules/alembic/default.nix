{ lib, buildPythonPackage, fetchPypi
, pytest, pytestcov, mock, coverage, setuptools
, Mako, sqlalchemy, python-editor, dateutil
}:

buildPythonPackage rec {
  pname = "alembic";
  version = "1.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5334f32314fb2a56d86b4c4dd1ae34b08c03cae4cb888bc699942104d66bc245";
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
