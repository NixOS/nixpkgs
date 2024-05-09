{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, arviz
, formulae
, graphviz
, pandas
, pymc
, blackjax
, numpyro
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "bambi";
  version = "0.13.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bambinos";
    repo = "bambi";
    rev = "refs/tags/${version}";
    hash = "sha256-9+uTyV3mQlHOKAjXohwkhTzNe/+I5XR/LuH1ZYvhc8I=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    arviz
    formulae
    graphviz
    pandas
    pymc
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  nativeCheckInputs = [
    blackjax
    numpyro
    pytestCheckHook
  ];

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
    "test_non_distributional_model"
    "test_normal_with_splines"
    "test_predict_offset"
    "test_predict_new_groups"
    "test_predict_new_groups_fail"
    "test_set_alias_warnings"
    "test_subplot_kwargs"
    "test_transforms"
    "test_use_hdi"
    "test_with_groups"
    "test_with_group_and_panel"
    "test_with_user_values"
  ];

  pythonImportsCheck = [
    "bambi"
  ];

  meta = with lib; {
    homepage = "https://bambinos.github.io/bambi";
    description = "High-level Bayesian model-building interface";
    changelog = "https://github.com/bambinos/bambi/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
