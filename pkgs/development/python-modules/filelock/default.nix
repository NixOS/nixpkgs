{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-fancy-pypi-readme,
  hatch-vcs,
  hatchling,
  pytest-asyncio,
  pytest-mock,
  pytest-timeout,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "filelock";
  version = "4.2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "filelock";
    tag = finalAttrs.version;
    hash = "sha256-JGmjNe6Q+QZ2cAxbhbZDCwT6u4AU+LVp5K0FJIlYHbk=";
  };

  build-system = [
    hatch-fancy-pypi-readme
    hatchling
    hatch-vcs
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [ "filelock" ];

  disabledTestPaths = [
    # Circular dependency with virtualenv
    "tests/test_virtualenv.py"
    # Very prone to timeouts on busy machines
    "tests/test_filelock.py"
    "tests/test_read_write.py"
  ];

  meta = {
    changelog = "https://github.com/tox-dev/filelock/blob/${finalAttrs.src.tag}/docs/changelog.rst";
    description = "Platform independent file lock for Python";
    homepage = "https://github.com/benediktschmitt/py-filelock";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
