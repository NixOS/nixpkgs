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
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyter-book";
    repo = "jupyter-book";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TpscnIywWNBd3eGMe8QDV1bqbTs1z2FbGJqAh/BCOg8=";
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-y2vZG64+ZtjANZgResUTVIoibK8GQIgKildpvTJypq4=";
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
