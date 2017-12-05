{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytestcov, mock, coverage
, Mako, sqlalchemy, python-editor, dateutil
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "alembic";
  version = "0.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "57f2ede554c0b18f1cf811cfbb3b02c586a5422df94922e3821883ba0b8c616c";
  };

  buildInputs = [ pytest pytestcov mock coverage ];
  propagatedBuildInputs = [ Mako sqlalchemy python-editor dateutil ];

  meta = with stdenv.lib; {
    homepage = http://bitbucket.org/zzzeek/alembic;
    description = "A database migration tool for SQLAlchemy";
    license = licenses.mit;
  };
}
