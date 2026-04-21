{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  filelock,
  gitpython,
  libbs,
  prompt-toolkit,
  pycparser,
  sortedcontainers,
  toml,
  tqdm,
  wordfreq,

  # optional-dependencies
  pyside6,

  # tests
  flask,
  pytest-qt,
  pytestCheckHook,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "binsync";
  version = "5.14.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "binsync";
    repo = "binsync";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5Thzj2fU9BFig2rnG00SWGkCpie6a4Ld5SZFZJE+Si4=";
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
    flask
    pyside6
    pytest-qt
    pytestCheckHook
    requests
  ];

  disabledTestPaths = [
    # Test tries to import angr-management
    "tests/test_angr_gui.py"

    # Fatal Python error: Aborted
    "tests/test_auxiliary_server.py"
  ];

  pythonImportsCheck = [ "binsync" ];

  meta = {
    description = "Reversing plugin for cross-decompiler collaboration, built on git";
    homepage = "https://github.com/binsync/binsync";
    changelog = "https://github.com/binsync/binsync/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ scoder12 ];
  };
})
