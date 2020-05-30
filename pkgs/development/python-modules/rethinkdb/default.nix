{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "rethinkdb";
  version = "2.4.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4eb4252b498af3f5d01e07d7870eb35f78b96bccc45812d313c14c5184789d74";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python driver library for the RethinkDB database server";
    homepage = "https://pypi.python.org/pypi/rethinkdb";
    license = licenses.agpl3;
  };

}
