{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,

  geopandas,
  libpysal,
  matplotlib,
  networkx,
  numpy,
  pandas,
  scikit-learn,
  scipy,
  setuptools-scm,
}:

buildPythonPackage {
  pname = "mapclassify";
  version = "2.10.0-unstable-2026-07-20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pysal";
    repo = "mapclassify";
    rev = "e8d0550986742de3a4aca6e4e590dfc48d384f0f";
    # tag = "v${version}";
    hash = "sha256-UIPMOdDh4sfcFzDqWE70krMywPgXEUOqvPXU73wJQuM=";
  };

  build-system = [ setuptools-scm ];

  # Temporary workaround, supply a PEP 440 compliant version
  env.SETUPTOOLS_SCM_PRETEND_VERSION = "2.10.0.dev20260720";

  propagatedBuildInputs = [
    networkx
    numpy
    pandas
    scikit-learn
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    geopandas
    libpysal
    matplotlib
  ];

  # requires network access
  disabledTestPaths = [
    # this module does http requests *at import time*
    "mapclassify/tests/test_greedy.py"
    # depends on remote data
    "mapclassify/tests/test_rgba.py"
  ];

  disabledTests = [
    # depends on remote datasets
    "test_legendgram_map"
    "test_legendgram_most_recent_cmap"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # RuntimeError: *** -[__NSPlaceholderArray initWithObjects:count:]: attempt to insert nil object from objects[1]
    "test_legendgram_returns_axis"
    "test_legendgram_standalone"
    "test_legendgram_inset_false"
    "test_legendgram_clip"
    "test_legendgram_tick_params"
    "test_legendgram_frameon"
    "test_legendgram_default"
    "test_legendgram_vlines"
    "test_legendgram_cmap"
    "test_legendgram_cmap_class"
    "test_legendgram_position"
    "test_legendgram_kwargs"
    "test_histogram_plot"
    "test_histogram_plot_despine"
    "test_histogram_plot_linewidth"
    "test_no_classify_default"
    "test_pass_in_ax"
    "test_classify_xy_redblue"
    "test_divergent_revert_alpha_min_alpha"
    "test_userdefined_colors"
    "test_shifted_colormap"
    "test_truncated_colormap"
    "test_legend"
    "test_legend_kwargs"
  ];

  pythonImportsCheck = [ "mapclassify" ];

  meta = {
    description = "Classification Schemes for Choropleth Maps";
    homepage = "https://pysal.org/mapclassify/";
    #changelog = "https://github.com/pysal/mapclassify/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.geospatial ];
  };
}
