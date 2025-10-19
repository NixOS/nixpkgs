{
  lib,
  python3Packages,
  fetchFromGitHub,
  pre-commit,
  versionCheckHook,
}:
python3Packages.buildPythonApplication rec {
  pname = "tt-smi";
  version = "3.0.30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "tt-smi";
    tag = "v${version}";
    hash = "sha256-C6CfcS0H3rFew/Y1uhmzICdFp1UYU7H9h3YPeAKlcbE=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    distro
    elasticsearch
    pydantic
    pyluwen
    rich
    textual
    pre-commit
    importlib-resources
    tt-tools-common
    setuptools
    tomli
  ];

  nativeCheckInputs = [
    versionCheckHook
  ];

  # Fails due to having no tests
  dontUsePytestCheck = true;

  versionCheckProgramArg = "--version";

  meta = {
    mainProgram = "tt-smi";
    description = "Tenstorrent console based hardware information program";
    homepage = "https://github.com/tenstorrent/tt-smi";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = with lib.licenses; [ asl20 ];
  };
}
