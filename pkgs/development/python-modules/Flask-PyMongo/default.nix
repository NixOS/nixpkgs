{ buildPythonPackage
, fetchPypi
, flask
, pymongo
, lib
, pytest
}:

buildPythonPackage rec {
  pname = "Flask-PyMongo";
  name = "${pname}-${version}";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2baaa2ba5107d72b3a8bd4b5c0c8881316e35340ad1ae979cc13f1f3c8843b3d";
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