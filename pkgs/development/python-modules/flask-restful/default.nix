{ lib
, aniso8601
, blinker
, buildPythonPackage
, fetchPypi
, flask
, mock
, nose
, pytestCheckHook
, pythonOlder
, pytz
, six
, werkzeug
}:

buildPythonPackage rec {
  pname = "flask-restful";
  version = "0.3.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Flask-RESTful";
    inherit version;
    hash = "sha256-zOxlC4NdSBkhOMhTKa4Dc15s7VjpstnCFG1shMBvpT4=";
  };

  patches = lib.optionals (lib.versionAtLeast werkzeug.version "2.1.0") [
    ./werkzeug-2.1.0-compat.patch
  ];

  propagatedBuildInputs = [
    aniso8601
    flask
    pytz
    six
  ];

  checkInputs = [
    blinker
    mock
    nose
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "flask_restful"
  ];

  meta = with lib; {
    description = "Framework for creating REST APIs";
    homepage = "https://flask-restful.readthedocs.io";
    longDescription = ''
      Flask-RESTful provides the building blocks for creating a great
      REST API.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
