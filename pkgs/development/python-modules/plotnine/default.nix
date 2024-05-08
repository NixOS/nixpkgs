{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  geopandas,
  matplotlib,
  mizani,
  pandas,
  patsy,
  pytestCheckHook,
  pythonOlder,
  scikit-misc,
  scipy,
  setuptools-scm,
  statsmodels,
}:

buildPythonPackage rec {
  pname = "plotnine";
  version = "0.13.5";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "has2k1";
    repo = "plotnine";
    rev = "refs/tags/v${version}";
    hash = "sha256-vGxsBcY4CRT4rBUq0AQ4oo0etKK+CtUD487VvnoK/rI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail " --cov=plotnine --cov-report=xml" ""
  '';

  build-system = [ setuptools-scm ];

  dependencies = [
    matplotlib
    mizani
    pandas
    patsy
    scipy
    statsmodels
  ];

  nativeCheckInputs = [
    geopandas
    pytestCheckHook
    scikit-misc
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "plotnine" ];

  disabledTestPaths = [
    # Assertion Errors:
    # Generated plot images do not exactly match the expected files.
    # After manually checking, this is caused by extremely subtle differences in label placement.
    "tests/test_aes.py"
    "tests/test_annotation_logticks.py"
    "tests/test_coords.py"
    "tests/test_facet_labelling.py"
    "tests/test_facets.py"
    "tests/test_geom_bar_col_histogram.py"
    "tests/test_geom_bin_2d.py"
    "tests/test_geom_boxplot.py"
    "tests/test_geom_count.py"
    "tests/test_geom_density_2d.py"
    "tests/test_geom_density.py"
    "tests/test_geom_dotplot.py"
    "tests/test_geom_freqpoly.py"
    "tests/test_geom_map.py"
    "tests/test_geom_path_line_step.py"
    "tests/test_geom_point.py"
    "tests/test_geom_raster.py"
    "tests/test_geom_rect_tile.py"
    "tests/test_geom_ribbon_area.py"
    "tests/test_geom_sina.py"
    "tests/test_geom_smooth.py"
    "tests/test_geom_text_label.py"
    "tests/test_geom_violin.py"
    "tests/test_layout.py"
    "tests/test_position.py"
    "tests/test_qplot.py"
    "tests/test_scale_internals.py"
    "tests/test_scale_labelling.py"
    "tests/test_stat_ecdf.py"
    "tests/test_stat_function.py"
    "tests/test_stat_summary.py"
    "tests/test_theme.py"

    # Linting / formatting: useless as it has nothing to do with the package functionning
    # Disabling this prevents adding a dependency on 'ruff' and 'black'.
    "tests/test_lint_and_format.py"
  ];

  meta = with lib; {
    description = "Grammar of graphics for Python";
    homepage = "https://plotnine.readthedocs.io/";
    changelog = "https://github.com/has2k1/plotnine/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
