{
  lib,
  buildPythonPackage,
  fetchPypi,
  genshi,
  gunicorn,
  jinja2,
  mako,
  pytestCheckHook,
  setuptools,
  sqlalchemy,
  virtualenv,
  webob,
  webtest,
}:

buildPythonPackage rec {
  pname = "pecan";
  version = "1.7.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-feFb9KJgDcWEvtDyVDHf7WvyCnpbyTWkjSzlAGMzmBU=";
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

  pytestFlags = [
    "--pyargs"
    "pecan"
  ];

  pythonImportsCheck = [ "pecan" ];

  meta = {
    description = "WSGI object-dispatching web framework";
    homepage = "https://www.pecanpy.org/";
    changelog = "https://github.com/pecan/pecan/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ applePrincess ];
  };
}
