{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  filelock,
  ghidra-bridge,
  jfx-bridge,
  networkx,
  platformdirs,
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

buildPythonPackage rec {
  pname = "libbs";
  version = "2.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "binsync";
    repo = "libbs";
    tag = "v${version}";
    hash = "sha256-hYRRmnxA6K7O6suaP1eGRnY89gok3JNNsL70XRGWYBU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    filelock
    ghidra-bridge
    jfx-bridge
    networkx
    platformdirs
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
