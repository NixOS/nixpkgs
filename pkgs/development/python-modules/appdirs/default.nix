{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "appdirs";
  version = "1.4.4";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-fV0BZ7KxuoIWR2Fq9Gp0nRxlN0DdDSQVEA/ibiev30E=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "appdirs" ];

  meta = {
    description = "Python module for determining appropriate platform-specific dirs";
    homepage = "https://github.com/ActiveState/appdirs";
    changelog = "https://github.com/ActiveState/appdirs/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
