{
  lib,
  python3Packages,
  fetchFromGitHub,
  pre-commit,
  versionCheckHook,
  tt-umd,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "tt-smi";
  version = "5.3.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "tt-smi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0Z8F1XdFvnx1q5AUA3RiMbfRyw2nlRVgxhKVotr4GrQ=";
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
    tt-umd
  ];

  pythonRelaxDeps = [ "tt-umd" ];

  nativeCheckInputs = [
    versionCheckHook
  ];

  # Fails due to having no tests
  dontUsePytestCheck = true;

  meta = {
    mainProgram = "tt-smi";
    description = "Tenstorrent console based hardware information program";
    homepage = "https://github.com/tenstorrent/tt-smi";
    changelog = "https://github.com/tenstorrent/tt-smi/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = with lib.licenses; [ asl20 ];
  };
})
