{ stdenv, buildPythonPackage, fetchPypi, flask, jinja2, itsdangerous, events
, markupsafe, pymongo, flask-pymongo, werkzeug, simplejson, cerberus }:

buildPythonPackage rec {
  pname = "Eve";
  version = "0.7.8";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "af373ab7b9611990d39b090eed372a0860d4e12a1c8a6ef49fdee29e4626053f";
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
