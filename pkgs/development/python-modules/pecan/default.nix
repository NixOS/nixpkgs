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
  version = "1.5.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YGMnLV+GB3P7tLSyrhsJ2oyVQGLvhxFQwGz9sjkdk1U=";
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
