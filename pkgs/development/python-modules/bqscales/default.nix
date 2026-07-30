{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # frontend
  nodejs,
  yarn-berry_3,

  # build-system
  hatchling,
  hatch-build-scripts,
  hatch-jupyter-builder,
  hatch-nodejs-version,
  jupyterlab,

  # dependencies
  ipywidgets,
  numpy,
  traitlets,
  traittypes,
}:

buildPythonPackage (finalAttrs: {
  pname = "bqscales";
  version = "0.3.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bqplot";
    repo = "bqscales";
    tag = finalAttrs.version;
    hash = "sha256-AAKnOEwdycSlxJEK0qbFJp2Dpiw/rEIk7fUa3NTymqQ=";
  };

  postPatch = ''
    sed -i "/\"hatch\"/d" pyproject.toml
  '';

  missingHashes = ./missing-hashes.json;

  yarnOfflineCache = yarn-berry_3.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-4Y5dRFwOyfHOzrdw2/epK3mN/+xrz+ccG86KP9axxjI=";
  };

  nativeBuildInputs = [
    nodejs
    yarn-berry_3.yarnBerryConfigHook
    yarn-berry_3
  ];

  preBuild = ''
    npm run build
  '';

  build-system = [
    hatch-build-scripts
    hatch-jupyter-builder
    hatch-nodejs-version
    hatchling
    jupyterlab
  ];

  dependencies = [
    ipywidgets
    numpy
    traitlets
    traittypes
  ];

  env.SKIP_JUPYTER_BUILDER = 1;

  # no tests in PyPI dist
  doCheck = false;

  pythonImportsCheck = [ "bqscales" ];

  meta = {
    description = "Grammar of Graphics scales for bqplot and other Jupyter widgets libraries";
    homepage = "https://github.com/bqplot/bqscales";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
})
