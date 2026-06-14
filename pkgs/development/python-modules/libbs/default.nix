{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  filelock,
  ghidra-bridge,
  jfx-bridge,
  networkx,
  platformdirs,
  ply,
  prompt-toolkit,
  psutil,
  pycparser,
  pyghidra,
  pyhidra,
  toml,
  tqdm,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  # Binary files from https://github.com/binsync/bs-artifacts (only used for testing and only here)
  binaries = fetchFromGitHub {
    owner = "binsync";
    repo = "bs-artifacts";
    tag = "514c2d6ef1875435c9d137bb5d99b6fc74063817";
    hash = "sha256-P7+BTJgdC9W8cC/7xQduFYllF+0ds1dSlm59/BFvZ2g=";
  };
in
buildPythonPackage (finalAttrs: {
  pname = "libbs";
  version = "3.4.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "binsync";
    repo = "libbs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gaMNwjW+B+H+bKscerJK8dbitJps9BGEIEZ4LY2Cm0c=";
  };

  build-system = [ setuptools ];

  env = {
    TEST_BINARIES_DIR = binaries.outPath;
  };

  pythonRelaxDeps = [
    "pycparser"
  ];
  dependencies = [
    filelock
    ghidra-bridge
    jfx-bridge
    networkx
    platformdirs
    ply
    prompt-toolkit
    psutil
    pycparser
    pyghidra
    pyhidra
    toml
    tqdm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "libbs" ];

  disabledTests = [
    # Require running ghidra
    "test_change_watcher_plugin_cli"
    "test_ghidra_artifact_watchers"

    # Require decompiler backends (ida, angr, ghidra) and pycparser.ply
    "TestClientServer"
    "TestHeadlessInterfaces"
  ];

  meta = {
    description = "Library for writing plugins in any decompiler: includes API lifting, common data formatting, and GUI abstraction";
    homepage = "https://github.com/binsync/libbs";
    changelog = "https://github.com/binsync/libbs/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ scoder12 ];
  };
})
