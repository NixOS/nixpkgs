{ stdenv, buildPythonPackage, fetchPypi, flask, events
, pymongo, simplejson, cerberus }:

buildPythonPackage rec {
  pname = "Eve";
  version = "0.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9f926c715f88c7a92dc2b950ccc09cccd91f72fe0e93cde806b85d25b947df2f";
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
