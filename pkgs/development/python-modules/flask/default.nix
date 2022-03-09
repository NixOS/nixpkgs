{ lib
, buildPythonPackage
, fetchPypi
, asgiref
, click
, itsdangerous
, jinja2
, python-dotenv
, werkzeug
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "2.0.2";
  pname = "Flask";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7b2fb8e934ddd50731893bdcdb00fc8c0315916f9fcd50d22c7cc1a95ab634e2";
  };

  propagatedBuildInputs = [
    asgiref
    python-dotenv
    click
    itsdangerous
    jinja2
    werkzeug

    # required for CLI subcommand autodiscovery
    # see: https://github.com/pallets/flask/blob/fdac8a5404e3e3a316568107a293f134707c75bb/src/flask/cli.py#L498
    setuptools
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
