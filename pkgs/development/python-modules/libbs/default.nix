{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  filelock,
  ghidra-bridge,
  jfx-bridge,
  networkx,
  platformdirs,
  ply,
  prompt-toolkit,
  psutil,
  pycparser,
  pyhidra,
  pytestCheckHook,
  setuptools,
  toml,
  tqdm,
  writableTmpDirAsHomeHook,
}:

let
  # Binary files from https://github.com/binsync/bs-artifacts (only used for testing and only here)
  binaries = fetchFromGitHub {
    owner = "binsync";
    repo = "bs-artifacts";
    rev = "514c2d6ef1875435c9d137bb5d99b6fc74063817";
    hash = "sha256-P7+BTJgdC9W8cC/7xQduFYllF+0ds1dSlm59/BFvZ2g=";
  };
in
buildPythonPackage rec {
  pname = "libbs";
  version = "2.16.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "binsync";
    repo = "libbs";
    tag = "v${version}";
    hash = "sha256-JE/eDs9vOiislIrsgBUx36XFenxgcoLtHA/veOMj2IY=";
  };

  build-system = [ setuptools ];

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
    pyhidra
    toml
    tqdm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  # Place test binaries in place
  preCheck = ''
    export HOME=$TMPDIR
    mkdir -p $HOME/bs-artifacts/binaries
    cp -r ${binaries} $HOME/bs-artifacts/binaries
    export TEST_BINARIES_DIR=$HOME/bs-artifacts/binaries
  '';

  pythonImportsCheck = [ "libbs" ];

  disabledTests = [
    "test_change_watcher_plugin_cli"
    "test_ghidra_artifact_watchers"
    "TestHeadlessInterfaces"
  ];

  meta = {
    description = "Library for writing plugins in any decompiler: includes API lifting, common data formatting, and GUI abstraction";
    homepage = "https://github.com/binsync/libbs";
    changelog = "https://github.com/binsync/libbs/releases/tag/${src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ scoder12 ];
  };
}
