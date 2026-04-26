{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  pytest-asyncio,
  pytest-mock,
  pytest-timeout,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "filelock";
  version = "3.29.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "filelock";
    tag = version;
    hash = "sha256-efBEyjuCcLkHsfpG61eKN6ALk4QW4UMdNmD56rSgFLc=";
  };

  build-system = [
    hatch-vcs
    hatchling
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
  ];

  meta = {
    changelog = "https://github.com/tox-dev/py-filelock/releases/tag/${version}";
    description = "Platform independent file lock for Python";
    homepage = "https://github.com/benediktschmitt/py-filelock";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
