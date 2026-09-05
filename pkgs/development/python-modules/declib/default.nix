{
  lib,
  buildPythonPackage,
  capstone,
  fetchFromGitHub,
  filelock,
  networkx,
  platformdirs,
  ply,
  prompt-toolkit,
  psutil,
  pycparser,
  pyghidra,
  pyside6,
  pytestCheckHook,
  setuptools,
  toml,
  tqdm,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "declib";
  version = "4.5.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "binsync";
    repo = "declib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u074QMyz9plYtRNSFGxFvzRsKiOxkfjQTh2sWVdP/II=";
  };

  build-system = [ setuptools ];

  dependencies = [
    filelock
    networkx
    platformdirs
    ply
    prompt-toolkit
    psutil
    pycparser
    pyghidra
    setuptools
    toml
    tqdm
  ];

  optional-dependencies = {
    ghidra = [ pyside6 ];
  };

  nativeCheckInputs = [
    capstone
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # Requires the unpackaged example plugin.
    "test_change_watcher_plugin_cli"
  ];

  disabledTestPaths = [
    # Requires a configured Ghidra installation and external fixtures.
    "tests/test_client_server.py"
    # Requires external Ghidra, IDA, and Binary Ninja installations and fixtures.
    "tests/test_decompilers.py"
  ];

  pythonImportsCheck = [ "declib" ];

  meta = {
    description = "Generic API for scripting decompilers";
    homepage = "https://github.com/binsync/declib";
    changelog = "https://github.com/binsync/declib/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ scoder12 ];
  };
})
