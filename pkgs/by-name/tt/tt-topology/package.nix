{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch,
  versionCheckHook,
}:
python3Packages.buildPythonApplication rec {
  pname = "tt-topology";
  version = "1.2.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "tt-topology";
    tag = "v${version}";
    hash = "sha256-hjUQMBTShdbl/tRlFF55P3kQDHi5gsGQVcGZSDgA0as=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    elasticsearch
    pydantic
    pyluwen
    tt-tools-common
    networkx
    matplotlib

    # Needed for "pkg_resources"
    setuptools
  ];

  nativeCheckInputs = [
    versionCheckHook
  ];

  pythonRemoveDeps = [
    "black"
    "pre-commit"
  ];

  # Remove when https://github.com/tenstorrent/tt-topology/pull/51 is merged
  pythonRelaxDeps = [
    "elasticsearch"
    "networkx"
    "matplotlib"
    "setuptools"
  ];

  # Tests are broken
  dontUsePytestCheck = true;

  versionCheckProgramArg = "--version";

  meta = {
    mainProgram = "tt-topology";
    description = "Command line utility used to flash multiple NB cards on a system to use specific eth routing configurations";
    homepage = "https://github.com/tenstorrent/tt-topology";
    changelog = "https://github.com/tenstorrent/tt-topology/blob/${src.tag}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = with lib.licenses; [ asl20 ];
  };
}
