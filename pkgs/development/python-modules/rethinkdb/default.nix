{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "rethinkdb";
  version = "2.4.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "945b5efdc10f468fc056bd53a4e4224ec4c2fe1a7e83ae47443bbb6e7c7a1f7d";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python driver library for the RethinkDB database server";
    homepage = "https://pypi.python.org/pypi/rethinkdb";
    license = licenses.agpl3;
  };

}
