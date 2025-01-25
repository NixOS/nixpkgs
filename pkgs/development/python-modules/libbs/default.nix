{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  filelock,
  ghidra-bridge,
  jfx-bridge,
  platformdirs,
  prompt-toolkit,
  psutil,
  pycparser,
  pyhidra,
  setuptools,
  toml,
  tqdm,
  wheel,
}:

buildPythonPackage rec {
  pname = "libbs";
  version = "2.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "binsync";
    repo = "libbs";
    tag = "v${version}";
    hash = "sha256-YCLl5e/ecZQ6MZwQ9FRDtBHLwG5DltYSaH5q4Xy5D0M=";
  };

  build-system = [ setuptools ];

  dependencies = [
    toml
    pycparser
    prompt-toolkit
    tqdm
    jfx-bridge
    ghidra-bridge
    psutil
    pyhidra
    platformdirs
    filelock
  ];

  pythonImportsCheck = [ "libbs" ];

  meta = {
    description = "Library for writing plugins in any decompiler: includes API lifting, common data formatting, and GUI abstraction";
    homepage = "https://github.com/binsync/libbs";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ scoder12 ];
  };
}
