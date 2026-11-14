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
  python-sbom,
}:

buildPythonPackage (finalAttrs: {
  pname = "filelock";
  version = "4.2.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "filelock";
    tag = finalAttrs.version;
    hash = "sha256-T+5mLG4+LZvpKQpdFuqtU9IAnhUWYGf996p60yCvCAk=";
  };

  build-system = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
    python-sbom
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
    changelog = "https://github.com/tox-dev/filelock/releases/tag/${finalAttrs.version}";
    description = "Platform independent file lock for Python";
    homepage = "https://github.com/benediktschmitt/py-filelock";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
