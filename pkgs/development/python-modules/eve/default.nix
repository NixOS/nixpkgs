{ stdenv, buildPythonPackage, fetchPypi, flask, events
, pymongo, simplejson, cerberus }:

buildPythonPackage rec {
  pname = "Eve";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "88105080e8a2567a1a8d50a5cded0d7d95e95f704b310c8107ef2ff7696f5316";
  };

  propagatedBuildInputs = [
    cerberus
    events
    flask
    pymongo
    simplejson
  ];

  # tests call a running mongodb instance
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "http://python-eve.org/";
    description = "Open source Python REST API framework designed for human beings";
    license = licenses.bsd3;
  };
}
