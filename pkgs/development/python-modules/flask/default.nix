{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  flit-core,

  # dependencies
  blinker,
  click,
  importlib-metadata,
  itsdangerous,
  jinja2,
  werkzeug,

  # optional-dependencies
  asgiref,
  python-dotenv,

  # tests
  pytestCheckHook,

  # reverse dependencies
  flask-limiter,
  flask-restful,
  flask-restx,
  moto,
}:

buildPythonPackage rec {
  pname = "flask";
  version = "3.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-v2VsFcgBkO1iitCM39Oqo1vrCHhV4vSUkQqjd0zE/Yc=";
  };

  build-system = [ flit-core ];

  dependencies = [
    click
    blinker
    itsdangerous
    jinja2
    werkzeug
  ]
  ++ lib.optionals (pythonOlder "3.10") [ importlib-metadata ];

  optional-dependencies = {
    async = [ asgiref ];
    dotenv = [ python-dotenv ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.flatten (lib.attrValues optional-dependencies);

  passthru.tests = {
    inherit
      flask-limiter
      flask-restful
      flask-restx
      moto
      ;
  };

  meta = {
    changelog = "https://flask.palletsprojects.com/en/stable/changes/#version-${
      lib.replaceStrings [ "." ] [ "-" ] version
    }";
    homepage = "https://flask.palletsprojects.com/";
    description = "Python micro framework for building web applications";
    mainProgram = "flask";
    longDescription = ''
      Flask is a lightweight WSGI web application framework. It is
      designed to make getting started quick and easy, with the ability
      to scale up to complex applications. It began as a simple wrapper
      around Werkzeug and Jinja and has become one of the most popular
      Python web application frameworks.
    '';
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
