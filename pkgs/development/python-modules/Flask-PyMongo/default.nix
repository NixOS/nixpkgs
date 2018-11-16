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
    sha256 = "0yi1r13p3l1d5dpdfnyp239l6l17nwvyky8y62nmmqxlsp2ja9hi";
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
