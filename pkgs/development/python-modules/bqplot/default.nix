{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  nodejs,
  yarn-berry_3,

  # build-system
  jupyter-packaging,
  jupyterlab,
  setuptools,

  # dependencies
  bqscales,
  ipywidgets,
  numpy,
  pandas,
  traitlets,
  traittypes,

  # tests
  nbval,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "bqplot";
  version = "0.13.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bqplot";
    repo = "bqplot";
    tag = finalAttrs.version;
    hash = "sha256-mYeQzmUa7WFDL8o6xsRD2bZ+3E9y4K/KyGE0zr0V4BA=";
  };

  yarnOfflineCache = yarn-berry_3.fetchYarnBerryDeps {
    src = "${finalAttrs.src}/js";
    hash = "sha256-/QSZoanK92pV8g3n92g2pK17XjNgyerSe4UCV1/stXY=";
  };

  nativeBuildInputs = [
    nodejs
    yarn-berry_3
    yarn-berry_3.yarnBerryConfigHook
  ];

  # The yarn workspace lives in `js/`, so the offline install has to run from there.
  dontYarnBerryInstallDeps = true;

  preBuild = ''
    pushd js
    yarnBerryConfigHook
    npm run build
    popd
  '';

  build-system = [
    jupyter-packaging
    jupyterlab
    setuptools
  ];

  dependencies = [
    bqscales
    ipywidgets
    numpy
    pandas
    traitlets
    traittypes
  ];

  nativeCheckInputs = [
    nbval
    pytestCheckHook
  ];

  enabledTestPaths = [ "tests/" ];

  pythonImportsCheck = [
    "bqplot"
    "bqplot.pyplot"
  ];

  meta = {
    description = "2D plotting library for Jupyter based on Grammar of Graphics";
    homepage = "https://bqplot.github.io/bqplot";
    downloadPage = "https://github.com/bqplot/bqplot";
    changelog = "https://github.com/bqplot/bqplot/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
})
