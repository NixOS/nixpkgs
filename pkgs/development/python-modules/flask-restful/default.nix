{ lib
, buildPythonPackage
, fetchPypi
, aniso8601
, flask
, pytz
, six
, blinker
, mock
, nose
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "Flask-RESTful";
  version = "0.3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gm5dz088v3d2k1dkcp9b3nnqpkk0fp2jly870hijj2xhc5nbv6c";
  };

  patches = [
    ./werkzeug-2.1.0-compat.patch
  ];

  propagatedBuildInputs = [
    aniso8601
    flask
    pytz
    six
  ];

  checkInputs = [
    pytestCheckHook
    mock
    nose
    blinker
  ];

  meta = with lib; {
    homepage = "https://flask-restful.readthedocs.io";
    description = "Simple framework for creating REST APIs";
    longDescription = ''
      Flask-RESTful provides the building blocks for creating a great
      REST API.
    '';
    license = licenses.bsd3;
  };
}
