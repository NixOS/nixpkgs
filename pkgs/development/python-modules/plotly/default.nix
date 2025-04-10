{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  packaging,
  narwhals,
  kaleido,
  pytestCheckHook,
  pandas,
  polars,
  pyarrow,
  requests,
  matplotlib,
  xarray,
  pillow,
  scipy,
  statsmodels,
  ipython,
  ipywidgets,
  which,
  nbformat,
  scikit-image,
  numpy,
}:

buildPythonPackage rec {
  pname = "plotly";
  version = "6.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "plotly";
    repo = "plotly.py";
    tag = "v${version}";
    hash = "sha256-UMXWczd87G535qMGOQDgxU9dBtsHSp+kA6MbdgLm8sY=";
  };

  env.SKIP_NPM = true;

  build-system = [ setuptools ];

  dependencies = [
    packaging
    narwhals
    kaleido
  ];

  # packages/python/plotly/optional-requirements.txt
  optional-dependencies = {
    express = [ numpy ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pandas
    polars
    pyarrow
    requests
    matplotlib
    xarray
    pillow
    scipy
    statsmodels
    ipython
    ipywidgets
    which
    nbformat
    scikit-image
  ];

  disabledTests = [
    # failed pinning test, sensitive to dep versions
    "test_legend_dots"
    "test_linestyle"
    # test bug, i assume sensitive to dep versions
    "test_sanitize_json"
    # lazy loading error, could it be the sandbox PYTHONPATH?
    # AssertionError: assert "plotly" not in sys.modules
    "test_dependencies_not_imported"
    "test_lazy_imports"
    # AssertionError: rgb(2...4, 96) != #fcff...a5
    "test_acceptance_named"
  ];

  disabledTestPaths =
    [
      # needs anywidget, but adding that requires building JS files
      "tests/test_io/test_to_from_json.py"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # requires local networking
      "tests/test_io/test_renderers.py"
      # a bunch of errors, recursion depth exceeded
      "tests/test_plotly_utils/validators"
      # fails to launch kaleido subprocess
      "tests/test_optional/test_kaleido"
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
      WeetHet
    ];
  };
}
