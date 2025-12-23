{
  lib,
  fetchFromGitHub,
  python3Packages,
  versionCheckHook,
}:
python3Packages.buildPythonApplication rec {
  pname = "tt-burnin";
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "tt-burnin";
    tag = "v${version}";
    hash = "sha256-/tnCLhA6zeUkVYhDtdohrZODwHxNTZbnsWgY2Gt16DQ=";
  };

  # Remove when https://github.com/NixOS/nixpkgs/pull/444714 is merged
  pythonRelaxDeps = [
    "pyluwen"
  ];

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    pyluwen
    tt-tools-common
    jsons
  ];

  nativeCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "--version";

  meta = {
    mainProgram = "tt-burnin";
    description = "Command line utility to run a high power consumption workload on TT devices";
    homepage = "https://github.com/tenstorrent/tt-burnin";
    changelog = "https://github.com/tenstorrent/tt-burnin/blob/${src.tag}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = with lib.licenses; [ asl20 ];
  };
}
