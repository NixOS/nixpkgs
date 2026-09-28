{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  flask,
  blinker,
  itsdangerous,
  werkzeug,
}:

buildPythonPackage (finalAttrs: {
  pname = "flask-debugtoolbar";
  version = "0.16.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pallets-eco";
    repo = "flask-debugtoolbar";
    tag = finalAttrs.version;
    hash = "sha256-qpVRMZPPegCsj9Rmo3tfNMlJAmPnaVTzGbqn1R0h3a4=";
  };

  build-system = [
    flit-core
  ];

  dependencies = [
    flask
  ];

  doCheck = false; # Tests require a running Flask application and are flaky in sandbox

  pythonImportsCheck = [ "flask_debugtoolbar" ];

  meta = {
    description = "Toolbar overlay for debugging Flask applications";
    longDescription = ''
      The Flask Debug Toolbar is an extension for Flask that adds a debugging toolbar to your app.
      It intercepts database queries, request properties, and other details.
    '';
    homepage = "https://flask-debugtoolbar.readthedocs.io/";
    changelog = "https://github.com/pallets-eco/flask-debugtoolbar/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
