{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  matplotlib,

  # optional-dependencies
  arviz,
  arviz-base,
  ipython,
  myst-nb,
  pandoc,
  sphinx,
  sphinx-book-theme,
  pytest,
  scipy,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "corner";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dfm";
    repo = "corner.py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H59IVXKPT4CLApn4kUuSuiYA9EWdOaH88Rd4YXf0VlQ=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [ matplotlib ];

  optional-dependencies = {
    arviz = [
      arviz
      arviz-base
    ];
    docs = [
      arviz
      arviz-base
      ipython
      myst-nb
      pandoc
      sphinx
      sphinx-book-theme
    ];
    test = [
      arviz
      pytest
      scipy
    ];
  };

  pythonImportsCheck = [ "corner" ];

  nativeCheckInputs = [
    arviz
    pytestCheckHook
    scipy
  ];

  disabledTests = [
    # matplotlib.testing.exceptions.ImageComparisonFailure: images not close
    "test_1d_fig_argument"
    "test_arviz"
    "test_basic"
    "test_bins"
    "test_bins_log"
    "test_color"
    "test_color_filled"
    "test_extended_overplotting"
    "test_hist_bin_factor"
    "test_labels"
    "test_levels2"
    "test_lowNfilled"
    "test_no_fill_contours"
    "test_overplot"
    "test_overplot_log"
    "test_pandas"
    "test_quantiles"
    "test_range_fig_arg"
    "test_reverse"
    "test_reverse_overplotting"
    "test_reverse_truths"
    "test_smooth1"
    "test_tight"
    "test_title_quantiles"
    "test_title_quantiles_default"
    "test_title_quantiles_raises"
    "test_titles1"
    "test_titles2"
    "test_titles_fmt_multi"
    "test_titles_fmt_single"
    "test_top_ticks"
    "test_truths"
  ];

  meta = {
    description = "Make some beautiful corner plots";
    homepage = "https://github.com/dfm/corner.py";
    changelog = "https://github.com/dfm/corner.py/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
