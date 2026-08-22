{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch,
  versionCheckHook,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "tt-topology";
  version = "1.2.20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "tt-topology";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oPhzNnlZszcXLSy29xfbhU5ML+twgeu2U794zdqSssI=";
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
    "pyluwen"
  ];

  # Tests are broken
  dontUsePytestCheck = true;

  meta = {
    mainProgram = "tt-topology";
    description = "Command line utility used to flash multiple NB cards on a system to use specific eth routing configurations";
    homepage = "https://github.com/tenstorrent/tt-topology";
    changelog = "https://github.com/tenstorrent/tt-topology/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = lib.licenses.asl20;
  };
})
