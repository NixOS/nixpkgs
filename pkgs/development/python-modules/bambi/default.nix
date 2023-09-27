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
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bambinos";
    repo = pname;
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
    "test_custom_prior"
    "test_data_is_copied"
    "test_distributional_model"
    "test_gamma_with_splines"
    "test_non_distributional_model_with_categories"
    "test_non_distributional_model"
    "test_normal_with_splines"
    "test_predict_offset"
    # Assertion issue
    "test_custom_likelihood_function"
  ];

  pythonImportsCheck = [
    "bambi"
  ];

  meta = with lib; {
    homepage = "https://bambinos.github.io/bambi";
    description = "High-level Bayesian model-building interface";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
