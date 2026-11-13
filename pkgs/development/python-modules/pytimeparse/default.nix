{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytimeparse";
  version = "1.1.10";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-7PDuYTpyywsdPVQEvTmKZCZldvw2zPMUkXivby7G9zY=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "pytimeparse/tests/testtimeparse.py" ];

  pythonImportsCheck = [ "pytimeparse" ];

  meta = {
    description = "Library to parse various kinds of time expressions";
    homepage = "https://github.com/wroberts/pytimeparse";
    changelog = "https://github.com/wroberts/pytimeparse/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
