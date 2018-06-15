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
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aab5ddab8f443e8a011e024f618bb89e078bdcc2274597079469fdf5ddc032b5";
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