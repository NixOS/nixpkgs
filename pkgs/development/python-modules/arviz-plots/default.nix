{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  arviz-base,
  arviz-stats,

  # optional-dependencies
  # bokeh
  bokeh,
  # doc
  h5netcdf,
  jupyter-sphinx,
  myst-nb,
  myst-parser,
  numpydoc,
  plotly,
  sphinx,
  sphinx-book-theme,
  sphinx-copybutton,
  sphinx-design,
  # matplotlib
  matplotlib,
  # plotly
  webcolors,
  # test
  hypothesis,
  kaleido,
  pytest,
  pytest-cov,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "arviz-plots";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "arviz-devs";
    repo = "arviz-plots";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ti1wD/aPNCk59wkad+xkvIKTB2Wkupovlo0Hg0YqK1o=";
  };

  build-system = [
    flit-core
  ];

  dependencies = [
    arviz-base
    arviz-stats
  ]
  # Otherwise, import fails with "ModuleNotFoundError: No module named 'xarray_einstats'"
  ++ arviz-stats.optional-dependencies.xarray;

  optional-dependencies = {
    bokeh = [
      bokeh
    ];
    doc = [
      h5netcdf
      jupyter-sphinx
      myst-nb
      myst-parser
      numpydoc
      plotly
      sphinx
      sphinx-book-theme
      sphinx-copybutton
      sphinx-design
    ];
    matplotlib = [
      matplotlib
    ];
    plotly = [
      plotly
      webcolors
    ];
    test = [
      h5netcdf
      hypothesis
      kaleido
      pytest
      pytest-cov
    ];
  };

  pythonImportsCheck = [ "arviz_plots" ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    # Prevents 'Fatal Python error: Aborted' on darwin during checkPhase
    MPLBACKEND = "Agg";
  };

  nativeCheckInputs = [
    bokeh
    h5netcdf
    hypothesis
    matplotlib
    plotly
    pytestCheckHook
    webcolors
  ];

  meta = {
    description = "ArviZ modular plotting";
    homepage = "https://github.com/arviz-devs/arviz-plots";
    changelog = "https://github.com/arviz-devs/arviz-plots/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
