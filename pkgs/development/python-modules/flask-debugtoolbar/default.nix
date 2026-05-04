{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  flask,
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

  build-system = [ flit-core ];

  dependencies = [ flask ];

  pythonImportsCheck = [ "flask_debugtoolbar" ];

  meta = {
    description = "Toolbar overlay for debugging Flask applications";
    homepage = "https://github.com/pallets-eco/flask-debugtoolbar";
    changelog = "https://github.com/pallets-eco/flask-debugtoolbar/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
