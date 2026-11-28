{
  buildPythonPackage,
  fetchPypi,
  lib,

  # build-system
  setuptools,
  setuptools-scm,
  # dependencies
  markupsafe,
  typing-extensions,
}:
buildPythonPackage (finalAttrs: {
  pname = "htpy";
  version = "26.5.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Q6NlwfxnAJTaeBuSOIMBkznOwDE5fWHV/l+OLyJ4tj4=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    markupsafe
    typing-extensions
  ];

  pythonImportsCheck = [ "htpy" ];

  meta = {
    description = "Library that makes writing HTML in plain Python fun and efficient, without a template language";
    homepage = "https://htpy.dev/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stefanboca ];
  };
})
