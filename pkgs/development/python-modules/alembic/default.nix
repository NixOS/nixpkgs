{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytestcov, mock, coverage
, Mako, sqlalchemy, python-editor, dateutil
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "alembic";
  version = "0.9.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13b8611788acf0d7b617775db5c2ae26554a6d4263c590ef628d448fd05aef56";
  };

  buildInputs = [ pytest pytestcov mock coverage ];
  propagatedBuildInputs = [ Mako sqlalchemy python-editor dateutil ];

  meta = with stdenv.lib; {
    homepage = https://bitbucket.org/zzzeek/alembic;
    description = "A database migration tool for SQLAlchemy";
    license = licenses.mit;
  };
}
