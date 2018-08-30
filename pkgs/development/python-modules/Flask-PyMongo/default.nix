{ buildPythonPackage
, fetchPypi
, flask
, pymongo
, lib
, pytest
}:

buildPythonPackage rec {
  pname = "Flask-PyMongo";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6a02add52ac245064720c2bb8b02074b9a5a0d9498279510ea2a537512fd3fa5";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test tests
  '';

  # Tests seem to hang
  doCheck = false;

  propagatedBuildInputs = [ flask pymongo ];

  meta = {
    homepage = "http://flask-pymongo.readthedocs.org/";
    description = "PyMongo support for Flask applications";
    license = lib.licenses.bsd2;
  };
}