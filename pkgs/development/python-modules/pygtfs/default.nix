{
  lib,
  buildPythonPackage,
  docopt,
  fetchPypi,
  pytz,
  setuptools,
  setuptools-scm,
  sqlalchemy,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pygtfs";
  version = "0.1.11";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-NaSGjzBBFK3mqHibcKV2gQIQoWn+qZay7KJasjcwxW4=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    docopt
    pytz
    sqlalchemy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "pygtfs/test/test.py" ];

  pythonImportsCheck = [ "pygtfs" ];

  meta = {
    description = "Python module for GTFS";
    homepage = "https://github.com/jarondl/pygtfs";
    changelog = "https://github.com/jarondl/pygtfs/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "gtfs2db";
  };
})
