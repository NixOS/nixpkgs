{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

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
  version = "0.11.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mJ7QOJGJrcR+3NJgHS6rGL82bnSwf14oc+AhMjxKFLs=";
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

  disabledTestPaths = [
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
    changelog = "https://github.com/holoviz/hvplot/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
