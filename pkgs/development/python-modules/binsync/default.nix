{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  filelock,
  gitpython,
  libbs,
  prompt-toolkit,
  pycparser,
  pyside6,
  pytest-qt,
  pytestCheckHook,
  setuptools,
  sortedcontainers,
  toml,
  tqdm,
  wordfreq,
}:

buildPythonPackage rec {
  pname = "binsync";
  version = "5.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "binsync";
    repo = "binsync";
    tag = "v${version}";
    hash = "sha256-C9yIb//h1pAJnlWT4+VgeVzeSjd0sfn8o4yfePNF/YM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    filelock
    gitpython
    libbs
    prompt-toolkit
    pycparser
    sortedcontainers
    toml
    tqdm
    wordfreq
  ];

  optional-dependencies = {
    ghidra = [ pyside6 ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-qt
    pyside6
  ];

  disabledTestPaths = [
    # Test tries to import angr-management
    "tests/test_angr_gui.py"
  ];

  pythonImportsCheck = [ "binsync" ];

  meta = {
    description = "Reversing plugin for cross-decompiler collaboration, built on git";
    homepage = "https://github.com/binsync/binsync";
    changelog = "https://github.com/binsync/binsync/releases/tag/${src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ scoder12 ];
  };
}
