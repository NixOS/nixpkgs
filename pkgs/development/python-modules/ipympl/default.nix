{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # frontend
  nodejs,
  yarn-berry_3,

  # build-system
  hatch-jupyter-builder,
  hatch-nodejs-version,
  hatchling,
  jupyterlab,

  # dependencies
  ipython,
  ipywidgets,
  matplotlib,
  numpy,
  pillow,
  traitlets,

  # tests
  importlib-metadata,
  nbval,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "ipympl";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "matplotlib";
    repo = "ipympl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IJ7tLUE0Ac4biQc9b87adgDcD8pa9XH1bo8rzDl9DCY=";
  };

  yarnOfflineCache = yarn-berry_3.fetchYarnBerryDeps {
    inherit (finalAttrs) src;
    hash = "sha256-tdfrAf2BSz9n83ctWqRxDHZnhnfhKA3BFNhXVr9wvLY=";
  };

  nativeBuildInputs = [
    nodejs
    yarn-berry_3.yarnBerryConfigHook
  ];

  build-system = [
    hatch-jupyter-builder
    hatch-nodejs-version
    hatchling
    jupyterlab
  ];

  dependencies = [
    ipython
    ipywidgets
    matplotlib
    numpy
    pillow
    traitlets
  ];

  nativeCheckInputs = [
    importlib-metadata
    nbval
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ipympl"
    "ipympl.backend_nbagg"
  ];

  meta = {
    changelog = "https://github.com/matplotlib/ipympl/releases/tag/${finalAttrs.src.tag}";
    description = "Matplotlib Jupyter Extension";
    homepage = "https://github.com/matplotlib/jupyter-matplotlib";
    maintainers = with lib.maintainers; [
      jluttine
      fabiangd
    ];
    license = lib.licenses.bsd3;
  };
})
