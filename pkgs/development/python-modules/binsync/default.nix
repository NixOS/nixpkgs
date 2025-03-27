{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  filelock,
  gitpython,
  libbs,
  prompt-toolkit,
  pycparser,
  pytestCheckHook,
  sortedcontainers,
  toml,
  tqdm,
  pyside6,
  flake8,
  pytest,
  pytest-qt,
}:

buildPythonPackage rec {
  pname = "binsync";
  version = "5.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "binsync";
    repo = "binsync";
    tag = "v${version}";
    hash = "sha256-kwwFwCy02nidSQamexyqq3fByjQCJMIrW9jPPTdqL6c=";
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
  ];

  optional-dependencies = {
    ghidra = [ pyside6 ];
  };

  doCheck = true;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-qt
    pyside6
  ];

  disabledTestPaths = [
    "tests/test_angr_gui.py" # tries to import angrmanagement
  ];

  pythonImportsCheck = [ "binsync" ];

  meta = {
    description = "A reversing plugin for cross-decompiler collaboration, built on git";
    homepage = "https://github.com/binsync/binsync";
    changelog = "https://github.com/binsync/binsync/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ scoder12 ];
  };
}
