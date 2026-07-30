{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  docutils,
  jupyter-server,
  jupyterlab-server,
  jupyterlite-core,
  jupytext,
  nbformat,
  sphinx,

  # optional-dependencies
  hatch,
  myst-parser,
  pydata-sphinx-theme,
}:

buildPythonPackage (finalAttrs: {
  pname = "jupyterlite-sphinx";
  version = "0.22.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jupyterlite";
    repo = "jupyterlite-sphinx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eww/VyHbAp78Bz2jg43XHmetEDrXEqXK45cnXHElG80=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    docutils
    jupyter-server
    jupyterlab-server
    jupyterlite-core
    finalAttrs.passthru.deps.jupytext
    nbformat
    sphinx
  ];

  optional-dependencies = {
    dev = [
      hatch
    ];
    docs = [
      #jupyterlite-xeus # missing, but not important
      myst-parser
      pydata-sphinx-theme
    ];
  };

  pythonRelaxDeps = [
    "jupyterlite-core"
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [
    "jupyterlite_sphinx"
  ];

  passthru.deps.jupytext = jupytext.overridePythonAttrs (oldAttrs: {
    # FIX: lots of flaky tests
    doCheck = false;
  });

  meta = {
    description = "Sphinx extension that integrates JupyterLite within your Sphinx documentation";
    homepage = "https://github.com/jupyterlite/jupyterlite-sphinx";
    changelog = "https://github.com/jupyterlite/jupyterlite-sphinx/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ eljamm ];
  };
})
