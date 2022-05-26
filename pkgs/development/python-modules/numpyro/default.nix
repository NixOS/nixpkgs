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
  version = "0.9.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-TbzyIt17/z56juc8kH1L8rTkvSgcsT5ah6xmvWTo6tM=";
  };

  propagatedBuildInputs = [
    jax
    jaxlib
    numpy
    multipledispatch
    tqdm
  ];

  checkInputs = [
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
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
