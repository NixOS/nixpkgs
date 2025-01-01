{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  packaging,
  tenacity,
  kaleido,
  pytestCheckHook,
  pandas,
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
  orca,
  psutil,
}:

buildPythonPackage rec {
  pname = "plotly";
  version = "5.24.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "plotly";
    repo = "plotly.py";
    rev = "refs/tags/v${version}";
    hash = "sha256-ONuX5/GlirPF8+7bZtib1Xsv5llcXcSelFfGyeTc5L8=";
  };

  sourceRoot = "${src.name}/packages/python/plotly";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "\"jupyterlab~=3.0;python_version>='3.6'\"," ""
  '';

  env.SKIP_NPM = true;

  build-system = [ setuptools ];

  dependencies = [
    packaging
    tenacity
    kaleido
  ];

  # packages/python/plotly/optional-requirements.txt
  optional-dependencies = {
    orca = [
      orca
      requests
      psutil
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pandas
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
    # requires vaex and polars, vaex is not packaged
    "test_build_df_from_vaex_and_polars"
    "test_build_df_with_hover_data_from_vaex_and_polars"
    # lazy loading error, could it be the sandbox PYTHONPATH?
    # AssertionError: assert "plotly" not in sys.modules
    "test_dependencies_not_imported"
    "test_lazy_imports"
  ];
  disabledTestPaths =
    [
      # unable to locate orca binary, adding the package does not fix it
      "plotly/tests/test_orca/"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
