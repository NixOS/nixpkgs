{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  httpsig,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pysmartapp";
  version = "0.3.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "andrewsayre";
    repo = "pysmartapp";
    tag = version;
    hash = "sha256-RiRGOO5l5hcHllyDDGLtQHr51JOTZhAa/wK8BfMqmAY=";
  };

  build-system = [ setuptools ];

  dependencies = [ httpsig ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pysmartapp" ];

  disabledTestPaths = [
    # These tests are outdated
    "tests/test_smartapp.py"
  ];

  meta = with lib; {
    description = "Python implementation to work with SmartApp lifecycle events";
    homepage = "https://github.com/andrewsayre/pysmartapp";
    changelog = "https://github.com/andrewsayre/pysmartapp/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
