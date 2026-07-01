{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  yarn-berry_3,
  nodejs,

  # build-system
  hatch-jupyter-builder,
  hatchling,
  jupyter-builder,

  # dependencies
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
  tomli,
  tornado,
  traitlets,

  # tests
  pytest-jupyter,
  pytestCheckHook,
  versionCheckHook,
}:

let
  yarn-berry = yarn-berry_3;
in
buildPythonPackage (finalAttrs: {
  pname = "jupyterlab";
  version = "4.6.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jupyterlab";
    repo = "jupyterlab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Vnx1TAWZmzecyUkBBYzy+0uBIJ3gFkA7pIW0kxQcc10=";
  };

  nativeBuildInputs = [
    nodejs
    yarn-berry.yarnBerryConfigHook
  ];

  build-system = [
    hatch-jupyter-builder
    hatchling
    jupyter-builder
  ];

  preConfigure = ''
    pushd jupyterlab/staging
  '';

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    sourceRoot = "${finalAttrs.src.name}/jupyterlab/staging";
    hash = "sha256-dvceVLXVRexcnZIxhBpsHFXrudr9p6S42btGqQbuDww=";
  };

  preBuild = ''
    popd
  '';

  dependencies = [
    async-lru
    httpx
    ipykernel
    jinja2
    jupyter-builder
    jupyter-core
    jupyter-lsp
    jupyter-server
    jupyterlab-server
    notebook-shim
    packaging
    tomli
    tornado
    traitlets
  ];

  preFixup = ''
    makeWrapperArgs+=(--set JUPYTERLAB_DIR "$out/share/jupyter/lab")
  '';

  # Ship a setup hook that seeds jupyter-builder's core-meta cache for any downstream JupyterLab
  # extension build (see the hook for details).
  postInstall = ''
    mkdir -p "$out/nix-support"

    substitute \
      ${./seed-core-meta-hook.sh} \
      "$out/nix-support/setup-hook" \
      --subst-var out
  '';

  pythonImportsCheck = [ "jupyterlab" ];

  nativeCheckInputs = [
    pytest-jupyter
    pytestCheckHook
    versionCheckHook
  ];

  disabledTests = [
    # Hang forever
    "TestExtension"

    # tornado.httpclient.HTTPClientError: HTTP 500: Internal Server Error
    "TestBuildAPI"
  ];

  meta = {
    description = "Jupyter lab environment notebook server extension";
    homepage = "https://jupyter.org/";
    downloadPage = "https://github.com/jupyterlab/jupyterlab";
    changelog = "https://github.com/jupyterlab/jupyterlab/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.jupyter ];
    mainProgram = "jupyter-lab";
  };
})
