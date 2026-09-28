{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "rcon";
  version = "2.4.9";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-1BqDEdwTNS2jUWP0ajzBPrIPXN4Sl7dbVudkXvdtCkg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/conqp/rcon/releases/tag/v${finalAttrs.version}";
    description = "Python RCON client library";
    homepage = "https://pypi.org/project/rcon/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jack-avery ];
  };
})
