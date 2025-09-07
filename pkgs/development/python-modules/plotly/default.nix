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
  version = "6.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "plotly";
    repo = "plotly.py";
    tag = "v${version}";
    hash = "sha256-s+kWJy/dOqlNqRD/Ytxy/SSRsFJvp13jSvPMd0LQliQ=";
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
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

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

  __darwinAllowLocalNetworking = true;

  disabledTestPaths = [
    # Broken imports
    "plotly/matplotlylib/mplexporter/tests"
    # Fails to catch error when serializing document
    "tests/test_optional/test_kaleido/test_kaleido.py::test_defaults"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # fails to launch kaleido subprocess
    "tests/test_optional/test_kaleido"
    # numpy2 related error, RecursionError
    # See: https://github.com/plotly/plotly.py/issues/4852
    "tests/test_plotly_utils/validators/test_angle_validator.py"
    "tests/test_plotly_utils/validators/test_any_validator.py"
    "tests/test_plotly_utils/validators/test_color_validator.py"
    "tests/test_plotly_utils/validators/test_colorlist_validator.py"
    "tests/test_plotly_utils/validators/test_colorscale_validator.py"
    "tests/test_plotly_utils/validators/test_dataarray_validator.py"
    "tests/test_plotly_utils/validators/test_enumerated_validator.py"
    "tests/test_plotly_utils/validators/test_fig_deepcopy.py"
    "tests/test_plotly_utils/validators/test_flaglist_validator.py"
    "tests/test_plotly_utils/validators/test_infoarray_validator.py"
    "tests/test_plotly_utils/validators/test_integer_validator.py"
    "tests/test_plotly_utils/validators/test_number_validator.py"
    "tests/test_plotly_utils/validators/test_pandas_series_input.py"
    "tests/test_plotly_utils/validators/test_string_validator.py"
    "tests/test_plotly_utils/validators/test_xarray_input.py"
  ];

  pythonImportsCheck = [ "plotly" ];

  meta = {
    description = "Python plotting library for collaborative, interactive, publication-quality graphs";
    homepage = "https://plot.ly/python/";
    downloadPage = "https://github.com/plotly/plotly.py";
    changelog = "https://github.com/plotly/plotly.py/blob/master/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pandapip1
      sarahec
    ];
  };
}
