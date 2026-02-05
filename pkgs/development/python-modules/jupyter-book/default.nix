{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchNpmDeps,

  # build-system
  hatch-deps-selector,
  hatch-jupyter-builder,
  hatch-nodejs-version,
  hatchling,

  # nativeBuildInputs
  nodejs,
  npmHooks,

  # dependencies
  jupyter-core,
  jupyter-server,
  ipykernel,
  nodeenv,

  # tests
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "jupyter-book";
  version = "2.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyter-book";
    repo = "jupyter-book";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eICmprxo/7E3GHVX4yK+L86pYHfQCBlx9WskbnBFCnY=";
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-uPmB6zrP1ESX7J3f5ppr7Yk9BupH8KI7a5OnYc/nN5M=";
  };

  build-system = [
    hatch-deps-selector
    hatch-jupyter-builder
    hatch-nodejs-version
    hatchling
  ];

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  # jupyter-book requires node at runtime
  propagatedBuildInputs = [
    nodejs
  ];

  dependencies = [
    ipykernel
    jupyter-core
    jupyter-server
    nodeenv
  ];

  pythonImportsCheck = [ "jupyter_book" ];

  # No python tests
  nativeCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Build a book with Jupyter Notebooks and Sphinx";
    homepage = "https://jupyterbook.org/";
    changelog = "https://github.com/jupyter-book/jupyter-book/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.jupyter ];
    mainProgram = "jupyter-book";
  };
})
