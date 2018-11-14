{ buildPythonPackage
, fetchPypi
, flask
, pymongo
, vcversioner
, lib
, pytest
}:

buildPythonPackage rec {
  pname = "Flask-PyMongo";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b99dd99985660ebbc4b34bb44550f88a527cbc573faa01febccce3c4ab28347";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  # Tests seem to hang
  doCheck = false;

  propagatedBuildInputs = [ flask pymongo vcversioner ];

  meta = {
    homepage = "http://flask-pymongo.readthedocs.org/";
    description = "PyMongo support for Flask applications";
    license = lib.licenses.bsd2;
  };
}
