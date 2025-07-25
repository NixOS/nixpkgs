{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  setuptools-scm,

  # dependencies
  matplotlib,
  mizani,
  pandas,
  scipy,
  statsmodels,

  # tests
  geopandas,
  pytestCheckHook,
  pytest-cov-stub,
  scikit-misc,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "plotnine";
  version = "0.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "has2k1";
    repo = "plotnine";
    tag = "v${version}";
    hash = "sha256-HhsJE5XoQjkIVExsfikTBArh9uq8ob4g2O0byYOsOh8=";
  };

  build-system = [ setuptools-scm ];

  patches = [
    (fetchpatch {
      name = "fix-composition-error-messages.patch";
      url = "https://github.com/has2k1/plotnine/commit/097192de42d690c227b26ae7638accac0db14589.patch";
      hash = "sha256-wxfJ36QH0PYdotgqrdE9sKAzKpcIYw7I8uNGhC6J0Gg=";
    })
  ];

  dependencies = [
    matplotlib
    mizani
    pandas
    scipy
    statsmodels
  ];

  nativeCheckInputs = [
    geopandas
    pytestCheckHook
    pytest-cov-stub
    scikit-misc
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "plotnine" ];

  disabledTests = [
    # Tries to change locale. The issued warning causes this test to fail.
    # UserWarning: Could not set locale to English/United States. Some date-related tests may fail
    "test_no_after_scale_warning"

    # Assertion Errors:
    # Generated plot images do not exactly match the expected files.
    # After manually checking, this is caused by extremely subtle differences in label placement.
    # See https://github.com/has2k1/plotnine/issues/627
    "test_aesthetics"
  ];

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
    "tests/test_geom_pointdensity.py"
    "tests/test_geom_polygon.py"
    "tests/test_geom_raster.py"
    "tests/test_geom_rect_tile.py"
    "tests/test_geom_ribbon_area.py"
    "tests/test_geom_sina.py"
    "tests/test_geom_smooth.py"
    "tests/test_geom_text_label.py"
    "tests/test_geom_violin.py"
    "tests/test_layout.py"
    "tests/test_plot_composition.py"
    "tests/test_position.py"
    "tests/test_qplot.py"
    "tests/test_scale_internals.py"
    "tests/test_scale_labelling.py"
    "tests/test_stat_ecdf.py"
    "tests/test_stat_ellipse.py"
    "tests/test_stat_function.py"
    "tests/test_stat_summary.py"
    "tests/test_theme.py"

    # Linting / formatting: useless as it has nothing to do with the package functioning
    # Disabling this prevents adding a dependency on 'ruff' and 'black'.
    "tests/test_lint_and_format.py"
  ];

  meta = {
    description = "Grammar of graphics for Python";
    homepage = "https://plotnine.readthedocs.io/";
    changelog = "https://github.com/has2k1/plotnine/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
  };
}
