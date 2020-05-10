{ stdenv
, buildPythonPackage
, fetchPypi
, flask
, events
, pymongo
, simplejson
, cerberus
, setuptools
}:

buildPythonPackage rec {
  pname = "Eve";
  version = "1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a7i7x77p5wjqfzmgn30m9sz2mcz06k4qf5af6a45109lafcq0bv";
  };

  propagatedBuildInputs = [
    cerberus
    events
    flask
    pymongo
    simplejson
    setuptools
  ];

  pythonImportsCheck = [ "eve" ];

  # tests call a running mongodb instance
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://python-eve.org/";
    description = "Open source Python REST API framework designed for human beings";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
