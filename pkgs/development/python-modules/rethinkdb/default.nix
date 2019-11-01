{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "rethinkdb";
  version = "2.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d01b39c1921498e22e3c9cae1adb39c37b68e4438ef77218abc0166fdfd2ea7a";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python driver library for the RethinkDB database server";
    homepage = "https://pypi.python.org/pypi/rethinkdb";
    license = licenses.agpl3;
  };

}
