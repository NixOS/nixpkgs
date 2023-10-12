{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
, arviz
, blackjax
, formulae
, graphviz
, numpy
, numpyro
, pandas
, pymc
, scipy
, setuptools
}:

buildPythonPackage rec {
  pname = "bambi";
  version = "0.12.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bambinos";
    repo = "bambi";
    rev = "refs/tags/${version}";
    hash = "sha256-36D8u813v2vWQdNqBWfM8YVnAJuLGvn5vqdHs94odmU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    arviz
    formulae
    numpy
    pandas
    pymc
    scipy
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  nativeCheckInputs = [
    blackjax
    graphviz
    numpyro
    pytestCheckHook
  ];

  disabledTests = [
    # Tests require network access
    "test_alias_equal_to_name"
    "test_custom_prior"
    "test_data_is_copied"
    "test_distributional_model"
    "test_extra_namespace"
    "test_gamma_with_splines"
    "test_non_distributional_model"
    "test_normal_with_splines"
    "test_predict_offset"
    "test_predict_new_groups"
    "test_predict_new_groups_fail"
    "test_set_alias_warnings"
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
