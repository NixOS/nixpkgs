{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  hatch-nodejs-version,

  # dependencies
  traitlets,
  jupyter-core,
  tomli,

  # tests
  copier,
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "jupyter-builder";
  version = "1.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyterlab";
    repo = "jupyter-builder";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FUCK2tKzL4sj5kld+Z/b/82RSRbyZjGNAqlwST9XH1w=";
  };

  build-system = [
    hatchling
    hatch-nodejs-version
  ];

  dependencies = [
    traitlets
    jupyter-core
    tomli
  ];

  nativeCheckInputs = [
    copier
    pytestCheckHook
    versionCheckHook
  ];

  disabledTestPaths = [
    # Require internet access
    "tests/test_tpl.py"
  ];

  meta = {
    description = "Build tools for JupyterLab";
    homepage = "https://github.com/jupyterlab/jupyter-builder";
    changelog = "https://github.com/jupyterlab/jupyter-builder/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.jupyter ];
    mainProgram = "jupyter-builder";
  };
})
