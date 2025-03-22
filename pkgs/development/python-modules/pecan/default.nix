{
  lib,
  fetchPypi,
  buildPythonPackage,
  logutils,
  mako,
  webob,
  webtest,
  pythonOlder,
  pytestCheckHook,
  genshi,
  gunicorn,
  jinja2,
  sqlalchemy,
  virtualenv,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pecan";
  version = "1.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-X9RGlYPu0t7Te00QpHDhGl3j88lj3IeYTncuJcVv7T4=";
  };

  propagatedBuildInputs = [
    logutils
    mako
    webob
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    genshi
    gunicorn
    jinja2
    sqlalchemy
    virtualenv
    webtest
  ];

  pytestFlagsArray = [ "--pyargs pecan" ];

  pythonImportsCheck = [ "pecan" ];

  meta = with lib; {
    changelog = "https://pecan.readthedocs.io/en/latest/changes.html";
    description = "WSGI object-dispatching web framework";
    homepage = "https://www.pecanpy.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ applePrincess ];
  };
}
