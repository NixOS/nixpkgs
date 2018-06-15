{ stdenv, buildPythonPackage, fetchPypi, flask, jinja2, itsdangerous, events
, markupsafe, pymongo, flask-pymongo, werkzeug, simplejson, cerberus }:

buildPythonPackage rec {
  pname = "Eve";
  version = "0.7.9";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e4ffa43be977997a4c6b62f5ab7996df3acf54c68824875fecd896da5af341a3";
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
