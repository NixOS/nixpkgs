{
  lib,
  buildPythonPackage,
  declib,
  fetchFromGitHub,
  filelock,
  flask,
  gitpython,
  ply,
  prompt-toolkit,
  pytest-qt,
  pytestCheckHook,
  requests,
  setuptools,
  sortedcontainers,
  toml,
  tqdm,
  writableTmpDirAsHomeHook,
  wordfreq,
}:

buildPythonPackage (finalAttrs: {
  pname = "binsync";
  version = "5.15.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "binsync";
    repo = "binsync";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4bxzNLgd42n4h1N4rwkMnL5WZ7zVSbEbgdfvlTlueNo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    declib
    filelock
    gitpython
    ply
    prompt-toolkit
    sortedcontainers
    toml
    tqdm
    wordfreq
  ]
  ++ declib.optional-dependencies.ghidra;

  nativeCheckInputs = [
    flask
    pytestCheckHook
    pytest-qt
    requests
    writableTmpDirAsHomeHook
  ];

  disabledTestPaths = [
    # Test imports angr-management, which depends on binsync.
    "tests/test_angr_gui.py"
    # Flaky teardown does not wait for QThreads before destroying them.
    "tests/test_auxiliary_server.py"
  ];

  env.QT_QPA_PLATFORM = "offscreen";

  pythonImportsCheck = [ "binsync" ];

  meta = {
    description = "Reversing plugin for cross-decompiler collaboration, built on git";
    homepage = "https://github.com/binsync/binsync";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ scoder12 ];
  };
})
