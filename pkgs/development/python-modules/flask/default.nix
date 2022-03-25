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
  version = "2.0.3";
  pname = "Flask";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4RIMIoyi9VO0cN9KX6knq2YlhGdSYGmYGz6wqRkCaH0=";
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
  };
}
