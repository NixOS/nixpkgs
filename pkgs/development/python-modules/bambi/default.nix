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
<<<<<<< HEAD
, setuptools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "bambi";
  version = "0.10.0";
<<<<<<< HEAD
  format = "pyproject";

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bambinos";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-D04eTAlckEqgKA+59BRljlyneHYoqqZvLYmt/gBLHcU=";
  };

<<<<<<< HEAD
  nativeBuildInputs = [
    setuptools
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    arviz
    formulae
    numpy
    pandas
    pymc
    scipy
  ];

<<<<<<< HEAD
  preCheck = ''
    export HOME=$(mktemp -d)
  '';
=======
  preCheck = ''export HOME=$(mktemp -d)'';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeCheckInputs = [
    blackjax
    graphviz
    numpyro
    pytestCheckHook
  ];
<<<<<<< HEAD

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
=======
  disabledTests = [
    # attempt to fetch data:
    "test_data_is_copied"
    "test_predict_offset"
  ];

  pythonImportsCheck = [ "bambi" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://bambinos.github.io/bambi";
    description = "High-level Bayesian model-building interface";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
