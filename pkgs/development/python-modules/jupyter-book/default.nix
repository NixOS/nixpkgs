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

buildPythonPackage rec {
  pname = "jupyter-book";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyter-book";
    repo = "jupyter-book";
    tag = "v${version}";
    hash = "sha256-Wh3ggKbV0mmcIbpIMsF09UH9ZyVOgpYAx4ppTSUHIKo=";
  };

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-oNTVzpjDb4bXIpuZcO/6f82UfOVxbkMMluwOKaNM5tE=";
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
    changelog = "https://github.com/jupyter-book/jupyter-book/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.jupyter ];
    mainProgram = "jupyter-book";
  };
}
