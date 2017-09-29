{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytestcov, mock, coverage
, Mako, sqlalchemy, python-editor, dateutil
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "alembic";
  version = "0.9.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8bdcb4babaa16b9a826f8084949cc2665cb328ecf7b89b3224b0ab85bd16fd05";
  };

  buildInputs = [ pytest pytestcov mock coverage ];
  propagatedBuildInputs = [ Mako sqlalchemy python-editor dateutil ];

  meta = with stdenv.lib; {
    homepage = http://bitbucket.org/zzzeek/alembic;
    description = "A database migration tool for SQLAlchemy";
    license = licenses.mit;
  };
}
