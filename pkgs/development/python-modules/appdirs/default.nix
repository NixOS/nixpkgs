{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "appdirs";
  version = "1.4.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fV0BZ7KxuoIWR2Fq9Gp0nRxlN0DdDSQVEA/ibiev30E=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "appdirs" ];

  meta = {
    description = "Python module for determining appropriate platform-specific dirs";
    homepage = "https://github.com/ActiveState/appdirs";
    changelog = "https://github.com/ActiveState/appdirs/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
