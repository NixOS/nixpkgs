{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytestcov, mock, coverage
, Mako, sqlalchemy, python-editor, dateutil
}:

buildPythonPackage rec {
  pname = "alembic";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04bcb970ca8659c3607ddd8ffd86cc9d6a99661c9bc590955e8813c66bfa582b";
  };

  buildInputs = [ pytest pytestcov mock coverage ];
  propagatedBuildInputs = [ Mako sqlalchemy python-editor dateutil ];

  meta = with stdenv.lib; {
    homepage = https://bitbucket.org/zzzeek/alembic;
    description = "A database migration tool for SQLAlchemy";
    license = licenses.mit;
  };
}
