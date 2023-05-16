{ lib
, buildPythonPackage
<<<<<<< HEAD
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchPypi
, jax
, jaxlib
, multipledispatch
, numpy
<<<<<<< HEAD
, tqdm
, funsor
, pytestCheckHook
, tensorflow-probability
=======
, pytestCheckHook
, pythonOlder
, tqdm
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "numpyro";
<<<<<<< HEAD
  version = "0.13.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-n+5K6fZlatKkXGVxzKcVhmP5XNuJeeM+GcCJ1Kh/WMk=";
=======
  version = "0.11.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-01fdGgFZ+G1FwjNwitM6PT1TQx0FtLvs4dBorkFoqo4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    jax
    jaxlib
<<<<<<< HEAD
    multipledispatch
    numpy
=======
    numpy
    multipledispatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    tqdm
  ];

  nativeCheckInputs = [
<<<<<<< HEAD
    funsor
    pytestCheckHook
    tensorflow-probability
=======
    pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonImportsCheck = [
    "numpyro"
  ];

  disabledTests = [
    # AssertionError due to tolerance issues
    "test_beta_binomial_log_prob"
    "test_collapse_beta"
    "test_cpu"
    "test_gamma_poisson"
    "test_gof"
    "test_hpdi"
<<<<<<< HEAD
    "test_kl_dirichlet_dirichlet"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "test_kl_univariate"
    "test_mean_var"
    # Tests want to download data
    "data_load"
    "test_jsb_chorales"
<<<<<<< HEAD
    # RuntimeWarning: overflow encountered in cast
    "test_zero_inflated_logits_probs_agree"
    # NameError: unbound axis name: _provenance
    "test_model_transformation"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    description = "Library for probabilistic programming with NumPy";
    homepage = "https://num.pyro.ai/";
    changelog = "https://github.com/pyro-ppl/numpyro/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
