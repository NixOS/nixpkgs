{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools-scm,

  # dependencies
  bokeh,
  colorcet,
  holoviews,
  pandas,

  # tests
  pytestCheckHook,
  dask,
  xarray,
  bokeh-sampledata,
  parameterized,
  selenium,
  matplotlib,
  scipy,
  plotly,
}:

buildPythonPackage rec {
  pname = "hvplot";
  version = "0.11.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "holoviz";
    repo = "hvplot";
    tag = "v${version}";
    hash = "sha256-V1KJtv1FCGITHdgxRWq1LWEgmWOU0N0iW60Wk0O5gC8=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    bokeh
    colorcet
    holoviews
    pandas
  ];

  nativeCheckInputs = [
    pytestCheckHook
    dask
    xarray
    bokeh-sampledata
    parameterized
    selenium
    matplotlib
    scipy
    plotly
  ];

  disabledTests = [
    # Legacy dask-expr implementation is deprecated
    # NotImplementedError: The legacy implementation is no longer supported
    "test_dask_dataframe_patched"
    "test_dask_series_patched"
  ];

  disabledTestPaths = [
    # Legacy dask-expr implementation is deprecated
    # NotImplementedError: The legacy implementation is no longer supported
    "hvplot/tests/plotting/testcore.py"
    "hvplot/tests/testcharts.py"
    "hvplot/tests/testgeowithoutgv.py"

    # All of the following below require xarray.tutorial files that require
    # downloading files from the internet (not possible in the sandbox).
    "hvplot/tests/testgeo.py"
    "hvplot/tests/testinteractive.py"
    "hvplot/tests/testui.py"
    "hvplot/tests/testutil.py"
  ];

  # need to set MPLBACKEND=agg for headless matplotlib for darwin
  # https://github.com/matplotlib/matplotlib/issues/26292
  preCheck = ''
    export MPLBACKEND=agg
  '';

  pythonImportsCheck = [ "hvplot.pandas" ];

  meta = {
    description = "High-level plotting API for the PyData ecosystem built on HoloViews";
    homepage = "https://hvplot.pyviz.org";
    changelog = "https://github.com/holoviz/hvplot/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
