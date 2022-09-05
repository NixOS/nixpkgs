{ lib
, buildPythonPackage
, fetchPypi
, asgiref
, click
, importlib-metadata
, itsdangerous
, jinja2
, python-dotenv
, werkzeug
, pytestCheckHook
, pythonOlder
  # used in passthru.tests
, flask-limiter
, flask-restful
, flask-restx
, moto
}:

buildPythonPackage rec {
  pname = "flask";
  version = "2.1.3";

  src = fetchPypi {
    pname = "Flask";
    inherit version;
    sha256 = "sha256-FZcuUBffBXXD1sCQuhaLbbkCWeYgrI1+qBOjlrrVtss=";
  };

  propagatedBuildInputs = [
    asgiref
    python-dotenv
    click
    itsdangerous
    jinja2
    werkzeug
  ] ++ lib.optional (pythonOlder "3.10") importlib-metadata;

  checkInputs = [
    pytestCheckHook
  ];

  passthru.tests = {
    inherit flask-limiter flask-restful flask-restx moto;
  };

  meta = with lib; {
    homepage = "https://flask.palletsprojects.com/";
    description = "The Python micro framework for building web applications";
    longDescription = ''
      Flask is a lightweight WSGI web application framework. It is
      designed to make getting started quick and easy, with the ability
      to scale up to complex applications. It began as a simple wrapper
      around Werkzeug and Jinja and has become one of the most popular
      Python web application frameworks.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
