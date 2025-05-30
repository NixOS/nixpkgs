{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  jupyter-packaging,
  setuptools,

  # dependencies
  narwhals,
  packaging,

  # optional-dependencies
  numpy,
  kaleido,

  # tests
  anywidget,
  ipython,
  ipywidgets,
  matplotlib,
  nbformat,
  pandas,
  pdfrw,
  pillow,
  polars,
  pyarrow,
  pytestCheckHook,
  requests,
  scikit-image,
  scipy,
  statsmodels,
  which,
  xarray,
}:

buildPythonPackage rec {
  pname = "plotly";
  version = "6.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "plotly";
    repo = "plotly.py";
    tag = "v${version}";
    hash = "sha256-B5wjZTnL/T+zRbPd3tVSekDbYnKBvIdIpXhc3sUvT3E=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"hatch", ' "" \
      --replace-fail "jupyter_packaging~=0.10.0" jupyter_packaging
  '';

  env.SKIP_NPM = true;

  build-system = [
    setuptools
    jupyter-packaging
  ];

  dependencies = [
    narwhals
    packaging
  ];

  optional-dependencies = {
    express = [ numpy ];
    kaleido = [ kaleido ];
  };

  nativeCheckInputs = [
    anywidget
    ipython
    ipywidgets
    matplotlib
    nbformat
    pandas
    pdfrw
    pillow
    polars
    pyarrow
    pytestCheckHook
    requests
    scikit-image
    scipy
    statsmodels
    which
    xarray
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  disabledTests = [
    # failed pinning test, sensitive to dep versions
    "test_legend_dots"
    "test_linestyle"
    # lazy loading error, could it be the sandbox PYTHONPATH?
    # AssertionError: assert "plotly" not in sys.modules
    "test_dependencies_not_imported"
    "test_lazy_imports"
    # [0.0, 'rgb(252, 255, 164)'] != [0.0, '#fcffa4']
    "test_acceptance_named"
  ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # requires local networking
    "plotly/tests/test_io/test_renderers.py"
    # fails to launch kaleido subprocess
    "plotly/tests/test_optional/test_kaleido"
  ];

  pythonImportsCheck = [ "plotly" ];

  meta = {
    description = "Python plotting library for collaborative, interactive, publication-quality graphs";
    homepage = "https://plot.ly/python/";
    downloadPage = "https://github.com/plotly/plotly.py";
    changelog = "https://github.com/plotly/plotly.py/blob/master/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
