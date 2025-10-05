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
  importlib-metadata,
  ipykernel,
  jinja2,
  jupyter-core,
  jupyter-lsp,
  jupyter-server,
  jupyterlab-server,
  notebook-shim,
  packaging,
  setuptools,
  tomli,
  tornado,
  traitlets,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "jupyterlab";
  version = "4.4.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyterlab";
    repo = "jupyterlab";
    tag = "v${version}";
    hash = "sha256-Joc8gtUJS8J2SLJqBV3f4bzmOje1grdgIMUkcwl9K44=";
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
    hash = "sha256-EwR1gVrEy7QV8DnJBPx1AlbWY10FFngpLXdAIKn1HI0=";
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
  ]
  ++ lib.optionals (pythonOlder "3.11") [ tomli ]
  ++ lib.optionals (pythonOlder "3.10") [ importlib-metadata ];

  makeWrapperArgs = [
    "--set"
    "JUPYTERLAB_DIR"
    "$out/share/jupyter/lab"
  ];

  # Depends on npm
  doCheck = false;

  pythonImportsCheck = [ "jupyterlab" ];

  meta = with lib; {
    changelog = "https://github.com/jupyterlab/jupyterlab/blob/${src.tag}/CHANGELOG.md";
    description = "Jupyter lab environment notebook server extension";
    license = licenses.bsd3;
    homepage = "https://jupyter.org/";
    teams = [ lib.teams.jupyter ];
    mainProgram = "jupyter-lab";
  };
}
