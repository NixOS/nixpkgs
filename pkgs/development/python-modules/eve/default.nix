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
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a8a1216ef1d3f1a4c4fc5a7bd315eca5a3ef7dfc6b78807cdf19ddfeecafcc3e";
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
