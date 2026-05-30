{
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  lib,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "inject";
  version = "5.3.0-unstable-2026-01-05";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ivankorobkov";
    repo = "python-inject";
    rev = "2ca60abc5370cd91d87e5a21ac373d0ca710f76d";
    hash = "sha256-FumossBUGwp1XxWthx3gpIietvZsmPpkd52y9jjVKjQ=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION =
    assert lib.hasInfix "unstable" finalAttrs.version;
    builtins.head (lib.splitString "-" finalAttrs.version);

  build-system = [
    hatchling
    hatch-vcs
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "inject" ];

  meta = {
    description = "Python dependency injection framework";
    homepage = "https://github.com/ivankorobkov/python-inject";
    changelog = "https://github.com/ivankorobkov/python-inject/blob/${finalAttrs.src.rev}/CHANGES.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ PerchunPak ];
  };
})
