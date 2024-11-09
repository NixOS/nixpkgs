{
  lib,
  arviz,
  blackjax,
  buildPythonPackage,
  fetchFromGitHub,
  formulae,
  graphviz,
  numpyro,
  pandas,
  pymc,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "bambi";
  version = "0.14.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "bambinos";
    repo = "bambi";
    rev = "refs/tags/${version}";
    hash = "sha256-kxrNNbZfC96/XHb1I7aUHYZdFJvGR80ZI8ell/0FQXc=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    arviz
    formulae
    graphviz
    pandas
    pymc
  ];

  # bayeux-ml is not available in nixpkgs
  # optional-dependencies = {
  #   jax = [ bayeux-ml ];
  # };

  nativeCheckInputs = [
    blackjax
    numpyro
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # Tests require network access
    "test_alias_equal_to_name"
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
    "test_predict_new_groups_fail"
    "test_predict_new_groups"
    "test_predict_offset"
    "test_set_alias_warnings"
    "test_subplot_kwargs"
    "test_transforms"
    "test_use_hdi"
    "test_with_group_and_panel"
    "test_with_groups"
    "test_with_user_values"
  ];

  disabledTestPaths = [
    # bayeux-ml is not available
    "tests/test_alternative_samplers.py"
    # Tests require network access
    "tests/test_interpret.py"
    "tests/test_interpret_messages.py"
  ];

  pythonImportsCheck = [ "bambi" ];

  meta = with lib; {
    description = "High-level Bayesian model-building interface";
    homepage = "https://bambinos.github.io/bambi";
    changelog = "https://github.com/bambinos/bambi/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
