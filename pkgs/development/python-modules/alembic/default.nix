{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytestcov, mock, coverage
, Mako, sqlalchemy, python-editor, dateutil
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "alembic";
  version = "0.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0iw6wysm83hycvrycymf9b4mkji47536kl3x7grynfcbyjcvbdm2";
  };

  buildInputs = [ pytest pytestcov mock coverage ];
  propagatedBuildInputs = [ Mako sqlalchemy python-editor dateutil ];

  meta = with stdenv.lib; {
    homepage = http://bitbucket.org/zzzeek/alembic;
    description = "A database migration tool for SQLAlchemy";
    license = licenses.mit;
  };
}
