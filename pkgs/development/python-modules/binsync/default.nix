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
}:

buildPythonPackage rec {
  pname = "binsync";
  version = "5.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "binsync";
    repo = "binsync";
    tag = "v${version}";
    hash = "sha256-f0pPuNTrZ5+iuJgtxLXJF89C9hKXwplhBA/olyhfsQ4=";
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

  nativeCheckInputs = [
    pytestCheckHook
    pytest-qt
    pyside6
  ];

  disabledTestPaths = [
    # Test tries to import angrmanagement
    "tests/test_angr_gui.py"
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
