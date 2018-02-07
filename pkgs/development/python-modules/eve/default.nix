{ stdenv, buildPythonPackage, fetchPypi, flask, jinja2, itsdangerous, events
, markupsafe, pymongo, flask-pymongo, werkzeug, simplejson, cerberus }:

buildPythonPackage rec {
  pname = "Eve";
  version = "0.7.6";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ba84ab471bc2203a728fe4707a9279c44420224180b418601778125f51577ff";
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
