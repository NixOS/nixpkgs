{ lib
, buildPythonPackage
, fetchPypi
, jax
, jaxlib
, multipledispatch
, numpy
, pytestCheckHook
, pythonOlder
, tqdm
}:

buildPythonPackage rec {
  pname = "numpyro";
  version = "0.11.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-01fdGgFZ+G1FwjNwitM6PT1TQx0FtLvs4dBorkFoqo4=";
  };

  propagatedBuildInputs = [
    jax
    jaxlib
    numpy
    multipledispatch
    tqdm
  ];

  nativeCheckInputs = [
    pytestCheckHook
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
    "test_kl_univariate"
    "test_mean_var"
    # Tests want to download data
    "data_load"
    "test_jsb_chorales"
  ];

  meta = with lib; {
    description = "Library for probabilistic programming with NumPy";
    homepage = "https://num.pyro.ai/";
    changelog = "https://github.com/pyro-ppl/numpyro/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
