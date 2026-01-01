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
<<<<<<< HEAD
  version = "5.8.0";
=======
  version = "5.7.11";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "binsync";
    repo = "binsync";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-AF5V1MBhWQQNtmwWZT1oT0CLj0impP4zqBTM5IHwzcI=";
=======
    hash = "sha256-Rn5ytC7j8HI64NQhvV4QjjBWDeYNkINJGUWDmZ7nQ3w=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
