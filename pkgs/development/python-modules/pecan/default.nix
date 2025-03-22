{
  lib,
  buildPythonPackage,
  fetchPypi,
  genshi,
  gunicorn,
  jinja2,
  mako,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  sqlalchemy,
  virtualenv,
  webob,
  webtest,
}:

buildPythonPackage rec {
  pname = "pecan";
  version = "1.6.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-X9RGlYPu0t7Te00QpHDhGl3j88lj3IeYTncuJcVv7T4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    mako
    setuptools
    webob
  ];

  nativeCheckInputs = [
    genshi
    gunicorn
    jinja2
    pytestCheckHook
    sqlalchemy
    virtualenv
    webtest
  ];

  pytestFlagsArray = [ "--pyargs pecan" ];

  pythonImportsCheck = [ "pecan" ];

  meta = with lib; {
    description = "WSGI object-dispatching web framework";
    homepage = "https://www.pecanpy.org/";
    changelog = "https://github.com/pecan/pecan/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ applePrincess ];
  };
}
