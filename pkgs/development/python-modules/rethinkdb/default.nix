{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "rethinkdb";
  version = "2.4.4.post1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e1c1f8ad93bc1c6f2aaa73afc333c57d505d8cc08c437d78a5c1eb8dc4b7e8c2";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python driver library for the RethinkDB database server";
    homepage = "https://pypi.python.org/pypi/rethinkdb";
    license = licenses.agpl3;
  };

}
