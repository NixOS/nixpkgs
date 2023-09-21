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
  version = "2.2.5";

  src = fetchPypi {
    pname = "Flask";
    inherit version;
    hash = "sha256-7e6bCn/yZiG9WowQ/0hK4oc3okENmbC7mmhQx/uXeqA=";
  };

  propagatedBuildInputs = [
    click
    itsdangerous
    jinja2
    werkzeug
  ] ++ lib.optional (pythonOlder "3.10") importlib-metadata;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  passthru.tests = {
    inherit flask-limiter flask-restful flask-restx moto;
  };
  passthru.optional-dependencies = {
    dotenv = [ python-dotenv ];
    async = [ asgiref ];
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
    maintainers = with maintainers; [ nickcao ];
  };
}
