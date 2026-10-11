{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  doit,
  jupyter-core,
  pycparser,
}:

buildPythonPackage (finalAttrs: {
  pname = "jupyterlite-core";
  version = "0.8.5";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jupyterlite";
    repo = "jupyterlite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7T5Kwy4A9h4F+yl2BkmdsOCmKBqmBbZ4/gZXfTKqTrU=";
  };

  sourceRoot = "${finalAttrs.src.name}/py/jupyterlite-core";

  build-system = [
    hatchling
  ];

  dependencies = [
    doit
    jupyter-core
    pycparser
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [
    "jupyterlite_core"
  ];

  meta = {
    description = "Wasm powered Jupyter running in the browser";
    homepage = "https://github.com/jupyterlite/jupyterlite";
    changelog = "https://github.com/jupyterlite/jupyterlite/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    mainProgram = "jupyter-lite";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [
      ngi
      jupyter
    ];
  };
})
