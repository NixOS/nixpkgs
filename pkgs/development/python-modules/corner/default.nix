{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  matplotlib,

  # optional-dependencies
  arviz,
  ipython,
  myst-nb,
  pandoc,
  sphinx,
  sphinx-book-theme,
  pytest,
  scipy,

  # checks
  pytestCheckHook,
  corner,
}:

buildPythonPackage rec {
  pname = "corner";
  version = "2.2.2";
  pyproject = true;

  disable = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "dfm";
    repo = "corner.py";
    rev = "refs/tags/v${version}";
    hash = "sha256-MYos01YCSUwivymSE2hbjV7eKXfaMqG89koD2CWZjcQ=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ matplotlib ];

  optional-dependencies = {
    arviz = [ arviz ];
    docs = [
      arviz
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

  nativeCheckInputs = [ pytestCheckHook ] ++ corner.optional-dependencies.test;

  # matplotlib.testing.exceptions.ImageComparisonFailure: images not close
  disabledTests = [
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
    "test_top_ticks"
    "test_truths"
  ];

  meta = {
    description = "Make some beautiful corner plots";
    homepage = "https://github.com/dfm/corner.py";
    changelog = "https://github.com/dfm/corner.py/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
