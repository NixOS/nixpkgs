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
    rev = "v${version}";
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
    test = [
      flake8
      pytest
      pytest-qt
    ];
  };

  pythonImportsCheck = [ "binsync" ];

  meta = {
    description = "A reversing plugin for cross-decompiler collaboration, built on git";
    homepage = "https://github.com/binsync/binsync";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ];
  };
}
