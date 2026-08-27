{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "appnope";
  version = "0.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "minrk";
    repo = "appnope";
    tag = finalAttrs.version;
    hash = "sha256-We7sZKVbQFIMdZpS+VMdi0RH1O/qtFNrfJNg/98tO5A=";
  };

  build-system = [ setuptools ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "appnope" ];

  meta = {
    description = "Disable App Nap on macOS";
    homepage = "https://github.com/minrk/appnope";
    changelog = "https://github.com/minrk/appnope/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ OPNA2608 ];
    # Not Darwin-specific because dummy fallback may be used cross-platform
  };
})
