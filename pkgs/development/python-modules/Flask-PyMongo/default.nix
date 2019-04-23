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
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "112625c5d5b4e35aad301ef9e937b7275043d310d75bd76e2b2dd07147c8217a";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  # Tests seem to hang
  doCheck = false;

  propagatedBuildInputs = [ flask pymongo vcversioner ];

  meta = {
    homepage = "https://flask-pymongo.readthedocs.org/";
    description = "PyMongo support for Flask applications";
    license = lib.licenses.bsd2;
  };
}
