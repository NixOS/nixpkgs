{ stdenv, buildPythonPackage, fetchPypi, flask, jinja2, itsdangerous, events
, markupsafe, pymongo, flask-pymongo, werkzeug, simplejson, cerberus }:

buildPythonPackage rec {
  pname = "Eve";
  version = "0.7.5";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dd4ffbc4725220ffdc8e32f8566c8870efaecdc238d0f96b18e1e83227eca55d";
  };

  patches = [
    ./setup.patch
  ];

  propagatedBuildInputs = [
    cerberus
    events
    flask-pymongo
    flask
    itsdangerous
    jinja2
    markupsafe
    pymongo
    simplejson
    werkzeug
  ];

  # tests call a running mongodb instance
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "http://python-eve.org/";
    description = "Open source Python REST API framework designed for human beings";
    license = licenses.bsd3;
  };
}
