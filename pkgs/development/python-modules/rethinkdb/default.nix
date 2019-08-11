{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "rethinkdb";
  version = "2.3.0.post6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05qwkmq6kn437ywyjs02jxbry720gw39q4z4jdb0cnbbi76lwddm";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python driver library for the RethinkDB database server";
    homepage = "https://pypi.python.org/pypi/rethinkdb";
    license = licenses.agpl3;
  };

}
