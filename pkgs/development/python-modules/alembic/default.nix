{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytestcov, mock, coverage
, Mako, sqlalchemy, python-editor, dateutil
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "alembic";
  version = "0.9.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "46f4849c6dce69f54dd5001b3215b6a983dee6b17512efee10e237fa11f20cfa";
  };

  buildInputs = [ pytest pytestcov mock coverage ];
  propagatedBuildInputs = [ Mako sqlalchemy python-editor dateutil ];

  meta = with stdenv.lib; {
    homepage = https://bitbucket.org/zzzeek/alembic;
    description = "A database migration tool for SQLAlchemy";
    license = licenses.mit;
  };
}
