{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "mistune";
  version = "3.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lepture";
    repo = "mistune";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gbdjLZ6caH4dgHAJoZcLcOFBfGUp5NJ4WbJj9+EleGg=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mistune" ];

  meta = {
    changelog = "https://github.com/lepture/mistune/blob/${finalAttrs.src.tag}/docs/changes.rst";
    description = "Sane Markdown parser with useful plugins and renderers";
    homepage = "https://github.com/lepture/mistune";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
