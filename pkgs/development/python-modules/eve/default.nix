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
  version = "1.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3a057277bba7144a0c15ab8c737dc8a1002e87e7284847aa011ce122e353418e";
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
