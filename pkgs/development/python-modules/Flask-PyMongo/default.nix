{ buildPythonPackage
, fetchPypi
, flask
, pymongo
, vcversioner
, lib
, pytest
}:

buildPythonPackage rec {
  pname = "flask-pymongo";
  version = "2.3.0";

  src = fetchPypi {
    pname = "Flask-PyMongo";
    inherit version;
    sha256 = "051kwdk07y4xm4yawcjhn6bz8swxp9nanv7jj35mz2l0r0nv03k2";
  };

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    pytest
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
