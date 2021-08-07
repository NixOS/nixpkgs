{ lib
, buildPythonPackage
, fetchPypi
, asgiref
, click
, itsdangerous
, jinja2
, python-dotenv
, werkzeug
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "2.0.1";
  pname = "Flask";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mcgwq7b4qd99mf5bsvs3wphchxarf8kgil4hwww3blj31xjak0w";
  };

  propagatedBuildInputs = [
    asgiref
    python-dotenv
    click
    itsdangerous
    jinja2
    werkzeug
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "http://flask.pocoo.org/";
    description = "The Python micro framework for building web applications";
    longDescription = ''
      Flask is a lightweight WSGI web application framework. It is
      designed to make getting started quick and easy, with the ability
      to scale up to complex applications. It began as a simple wrapper
      around Werkzeug and Jinja and has become one of the most popular
      Python web application frameworks.
    '';
    license = licenses.bsd3;
  };
}
