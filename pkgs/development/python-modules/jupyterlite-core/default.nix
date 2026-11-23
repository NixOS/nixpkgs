{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,

  # build-system
  hatchling,

  # dependencies
  doit,
  jupyter-core,
  pycparser,
}:

buildPythonPackage (finalAttrs: {
  pname = "jupyterlite-core";
  version = "0.8.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyterlite";
    repo = "jupyterlite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NhEASYiPdu/lkBUCiH4nVI6iEBb9v3Djs/9N+BovfgA=";
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

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex=^v(\\d+).(\\d+).(\\d+)$"
      "--use-github-releases"
    ];
  };

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
