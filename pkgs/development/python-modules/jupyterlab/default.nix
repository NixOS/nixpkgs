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

buildPythonPackage (finalAttrs: {
  pname = "jupyterlab";
  version = "4.5.8";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jupyterlab";
    repo = "jupyterlab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OtytFZdgGzbQF3icglwRpAn0HhJNyjI6oNS01gfpzkA=";
  };

  nativeBuildInputs = [
    nodejs
    yarn-berry_3.yarnBerryConfigHook
  ];

  preConfigure = ''
    pushd jupyterlab/staging
  '';

  offlineCache = yarn-berry_3.fetchYarnBerryDeps {
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/jupyterlab/staging";
    hash = "sha256-wgqwEl01VinYU5haL1X8Na1lNNcyqCfRaRBze4ypPPo=";
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
    changelog = "https://github.com/jupyterlab/jupyterlab/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Jupyter lab environment notebook server extension";
    license = lib.licenses.bsd3;
    homepage = "https://jupyter.org/";
    teams = [ lib.teams.jupyter ];
    mainProgram = "jupyter-lab";
  };
})
