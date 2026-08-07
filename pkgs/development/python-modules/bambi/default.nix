{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  arviz-plots,
  formulae,
  graphviz,
  matplotlib,
  pandas,
  pymc,
  pytensor,
  seaborn,
  sparse,

  # tests
  blackjax,
  numpyro,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "bambi";
  version = "0.19.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bambinos";
    repo = "bambi";
    tag = finalAttrs.version;
    hash = "sha256-2BLbvdVN+wkmP2NCGaBoJO10hbBXUJ1/Q7bjRN4idWM=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [
    "sparse"
  ];
  dependencies = [
    arviz-plots
    formulae
    graphviz
    matplotlib
    pandas
    pymc
    pytensor
    seaborn
    sparse
  ];

  optional-dependencies = {
    jax = [
      # not (yet) available in nixpkgs (https://github.com/NixOS/nixpkgs/pull/345438)
      # bayeux-ml
    ];
  };

  nativeCheckInputs = [
    # bayeux-ml
    blackjax
    numpyro
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # Requires `nutpie`, which is not packaged in nixpkgs
    "test_nuts_parameter_forwarded_to_external_samplers"

    # ValueError: dtype attribute is not a valid dtype instance
    "test_vonmises_regression"

    # AssertionError: assert (<xarray.DataArray 'yield' ()> Size: 1B\narray(False) & <xarray.DataArray 'yield' ()> Size: 1B\narray(False))
    # https://github.com/bambinos/bambi/issues/888
    "test_beta_regression"

    # Failing since blackjax was updated to 1.4
    # ValueError: cannot select an axis to squeeze out which has size not equal to one,
    # got shape=(4, 2) and dimensions=(0,)
    "test_blackjax_method"
    "test_legacy_nuts_blackjax_warning"

    # Tests require network access
    "test_alias_equal_to_name"
    "test_exclusion"
    "test_inplace_false"
    "test_average_by"
    "test_ax"
    "test_basic"
    "test_censored_response"
    "test_custom_prior"
    "test_data_is_copied"
    "test_distributional_model"
    "test_elasticity"
    "test_extra_namespace"
    "test_fig_kwargs"
    "test_gamma_with_splines"
    "test_group_effects"
    "test_hdi_prob"
    "test_legend"
    "test_model_with_group_specific_effects"
    "test_model_with_intercept"
    "test_model_without_intercept"
    "test_non_distributional_model"
    "test_normal_with_splines"
    "test_predict_new_groups"
    "test_predict_new_groups_fail"
    "test_predict_offset"
    "test_same_variable_conditional_and_group"
    "test_set_alias_warnings"
    "test_subplot_kwargs"
    "test_transforms"
    "test_use_hdi"
    "test_with_group_and_panel"
    "test_with_groups"
    "test_with_user_values"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    # Python crash (in matplotlib)
    # Fatal Python error: Aborted
    "test_categorical_response"
    "test_multiple_hsgp_and_by"
    "test_multiple_outputs_with_alias"
    "test_plot_priors"
    "test_term_transformations"
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/test_interpret_plots.py"
  ];

  pythonImportsCheck = [ "bambi" ];

  meta = {
    description = "High-level Bayesian model-building interface";
    homepage = "https://bambinos.github.io/bambi";
    changelog = "https://github.com/bambinos/bambi/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
})
