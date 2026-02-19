{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nodejs,
  yarn-berry_3,
  hatch-jupyter-builder,
  hatchling,
  async-lru,
  httpx,
  ipykernel,
  jinja2,
  jupyter-core,
  jupyter-lsp,
  jupyter-server,
  jupyterlab-server,
  notebook-shim,
  packaging,
  setuptools,
  tornado,
  traitlets,
}:

buildPythonPackage rec {
  pname = "jupyterlab";
  version = "4.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyterlab";
    repo = "jupyterlab";
    tag = "v${version}";
    hash = "sha256-3vKz79/19F4kZeTjHSChgwAsM8quzIVBmjiRekA/8vo=";
  };

  nativeBuildInputs = [
    nodejs
    yarn-berry_3.yarnBerryConfigHook
  ];

  preConfigure = ''
    pushd jupyterlab/staging
  '';

  offlineCache = yarn-berry_3.fetchYarnBerryDeps {
    inherit src;
    sourceRoot = "${src.name}/jupyterlab/staging";
    hash = "sha256-3Gvbsi/oi8lTRrCYut126zsksjSSWmfJCoRxDmjne1E=";
  };

  preBuild = ''
    popd
  '';

  build-system = [
    hatch-jupyter-builder
    hatchling
  ];

  dependencies = [
    async-lru
    httpx
    ipykernel
    jinja2
    jupyter-core
    jupyter-lsp
    jupyter-server
    jupyterlab-server
    notebook-shim
    packaging
    setuptools
    tornado
    traitlets
  ];

  makeWrapperArgs = [
    "--set"
    "JUPYTERLAB_DIR"
    "$out/share/jupyter/lab"
  ];

  # Depends on npm
  doCheck = false;

  pythonImportsCheck = [ "jupyterlab" ];

  meta = {
    changelog = "https://github.com/jupyterlab/jupyterlab/blob/${src.tag}/CHANGELOG.md";
    description = "Jupyter lab environment notebook server extension";
    license = lib.licenses.bsd3;
    homepage = "https://jupyter.org/";
    teams = [ lib.teams.jupyter ];
    mainProgram = "jupyter-lab";
  };
}
