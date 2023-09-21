{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, jax
, jaxlib
, multipledispatch
, numpy
, tqdm
, funsor
, pytestCheckHook
, tensorflow-probability
}:

buildPythonPackage rec {
  pname = "numpyro";
  version = "0.13.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-n+5K6fZlatKkXGVxzKcVhmP5XNuJeeM+GcCJ1Kh/WMk=";
  };

  propagatedBuildInputs = [
    jax
    jaxlib
    multipledispatch
    numpy
    tqdm
  ];

  nativeCheckInputs = [
    funsor
    pytestCheckHook
    tensorflow-probability
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
    "test_kl_dirichlet_dirichlet"
    "test_kl_univariate"
    "test_mean_var"
    # Tests want to download data
    "data_load"
    "test_jsb_chorales"
    # RuntimeWarning: overflow encountered in cast
    "test_zero_inflated_logits_probs_agree"
    # NameError: unbound axis name: _provenance
    "test_model_transformation"
  ];

  meta = with lib; {
    description = "Library for probabilistic programming with NumPy";
    homepage = "https://num.pyro.ai/";
    changelog = "https://github.com/pyro-ppl/numpyro/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
